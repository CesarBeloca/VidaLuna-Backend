import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import pkg from 'pg';
import nodemailer from 'nodemailer';

console.log('DATABASE_URL:', process.env.DATABASE_URL ? 'set' : 'MISSING');

const {Pool} = pkg;

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

const pool = new Pool({
    connectionString: process.env.DATABASE_URL, ssl: {rejectUnauthorized: false}
});

// --- Email Transporter Setup ---
const createEmailTransporter = () => {
    if (!process.env.SMTP_HOST || !process.env.SMTP_PORT || !process.env.SMTP_USER || !process.env.SMTP_PASSWORD) {
        console.warn('⚠️ Email configuration is missing. Email sending will not work.');
        return null;
    }
    const transporter = nodemailer.createTransport({
        host: process.env.SMTP_HOST,
        port: parseInt(process.env.SMTP_PORT, 10),
        secure: false,
        auth: {
            user: process.env.SMTP_USER,
            pass: process.env.SMTP_PASSWORD,
        },
    });
    transporter.verify((error, success) => {
        if (error) {
            console.error('❌ Email transporter verification failed:', error);
        } else {
            console.log('✅ Email transporter is ready to send messages');
        }
    });
    return transporter;
};
const emailTransporter = createEmailTransporter();

const generateOrderEmailHtml = (orderData) => {
    // orderData should contain customer_name, orderId, items, total_cents, token
    const itemsHtml = orderData.items.map(item => `
        <tr>
            <td style="padding: 12px; border-bottom: 1px solid #eee;">${item.name}</td>
            <td style="padding: 12px; border-bottom: 1px solid #eee; text-align: center;">${item.quantity}</td>
            <td style="padding: 12px; border-bottom: 1px solid #eee; text-align: right;">Kč ${(item.price_cents_at_time / 100).toFixed(2)}</td>
        </tr>
    `).join('');

    const totalPriceKc = (orderData.total_cents / 100).toFixed(2);
    const orderLink = `http://localhost:5000/api/orders/${orderData.token}`; // We'll change this to your frontend URL later

    return `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>Vida Luna Order Confirmation</title>
            <style>
                body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; line-height: 1.6; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { text-align: center; padding: 20px 0; border-bottom: 2px solid #eee; margin-bottom: 30px; }
                .order-details { background-color: #f9f9f9; padding: 20px; border-radius: 8px; margin: 20px 0; }
                table { width: 100%; border-collapse: collapse; margin: 15px 0; }
                th { text-align: left; padding: 12px; background-color: #f2f2f2; }
                .total { text-align: right; font-weight: bold; font-size: 1.2em; margin-top: 20px; }
                .footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; color: #777; font-size: 0.9em; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>✨ Vida Luna ✨</h1>
                    <p>Thank you for your order!</p>
                </div>
                <p>Dear <strong>${orderData.customer_name}</strong>,</p>
                <p>We're so happy you've chosen to bring a piece of nature into your home. Here's the confirmation of your order:</p>
                
                <div class="order-details">
                    <p><strong>Order Number:</strong> #${orderData.orderId}</p>
                    <p><strong>Order Date:</strong> ${new Date().toLocaleString()}</p>
                    
                    <h3>Order Summary</h3>
                    <table>
                        <thead>
                            <tr><th>Product</th><th style="text-align: center;">Qty</th><th style="text-align: right;">Price</th></tr>
                        </thead>
                        <tbody>
                            ${itemsHtml}
                        </tbody>
                    </table>
                    <div class="total">
                        <strong>Total: Kč ${totalPriceKc}</strong> <span style="font-size: 0.9em;">(incl. VAT)</span>
                    </div>
                </div>
                
                <p>You can check your order status anytime using this link:</p>
                <p><a href="${orderLink}" target="_blank">${orderLink}</a></p>
                <p>We'll send you another email when your order ships.</p>
                
                <div class="footer">
                    <p>Love and moonbeams,<br>The Vida Luna Team</p>
                    <p><small>This is a transactional email related to your purchase.</small></p>
                </div>
            </div>
        </body>
        </html>
    `;
};

// ========== PRODUCTS ==========

// GET /api/products - list all products (optional category filter)
app.get('/api/products', async (req, res) => {
    const lang = req.query.lang || 'en';
    const { category } = req.query;
    try {
        let query = `
            SELECT p.id, p.slug, p.price_cents, p.category, p.image_url, p.in_stock,
                   COALESCE(pt.name, p.slug) AS name,
                   pt.intro_text,
                   pt.full_description,
                   pt.ingredients_text,
                   pt.season,
                   pt.goddess
            FROM products p
            LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = $1
        `;
        const params = [lang];
        if (category) {
            query += ' WHERE p.category = $2';
            params.push(category);
        }
        query += ' ORDER BY p.id ASC';
        const result = await pool.query(query, params);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// GET /api/products/:slug - single product detail
app.get('/api/products/:slug', async (req, res) => {
    const { slug } = req.params;
    const lang = req.query.lang || 'en';
    try {
        const result = await pool.query(`
            SELECT p.id, p.slug, p.price_cents, p.category, p.image_url, p.in_stock,
                   COALESCE(pt.name, p.slug) AS name,
                   pt.intro_text,
                   pt.full_description,
                   pt.ingredients_text,
                   pt.season,
                   pt.goddess
            FROM products p
                     LEFT JOIN product_translations pt ON p.id = pt.product_id AND pt.language_code = $1
            WHERE p.slug = $2
        `, [lang, slug]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Product not found' });
        }
        const product = result.rows[0];
        // If product is a kit, fetch its components (no translations for components – you can extend later)
        if (product.category === 'kit') {
            const compResult = await pool.query(`
                SELECT p.*, pr.quantity
                FROM product_relations pr
                         JOIN products p ON pr.component_id = p.id
                WHERE pr.kit_id = $1
            `, [product.id]);
            product.components = compResult.rows;
        }
        res.json(product);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// GET /api/ingredients?lang=en
app.get('/api/ingredients', async (req, res) => {
    const lang = req.query.lang || 'en';
    try {
        const result = await pool.query(`
      SELECT i.id, i.slug, i.image_url,
             COALESCE(it.name, i.slug) AS name,
             COALESCE(it.description, '') AS description
      FROM ingredients i
      LEFT JOIN ingredient_translations it ON i.id = it.ingredient_id AND it.language_code = $1
      ORDER BY it.name
    `, [lang]);
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// GET /api/ingredients/:slug?lang=en
app.get('/api/ingredients/:slug', async (req, res) => {
    const { slug } = req.params;
    const lang = req.query.lang || 'en';
    try {
        const result = await pool.query(`
      SELECT i.id, i.slug, i.image_url,
             COALESCE(it.name, i.slug) AS name,
             COALESCE(it.description, '') AS description
      FROM ingredients i
      LEFT JOIN ingredient_translations it ON i.id = it.ingredient_id AND it.language_code = $1
      WHERE i.slug = $2
    `, [lang, slug]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Ingredient not found' });
        }
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});

// ========== ORDERS (guest checkout) ==========

// POST /api/orders
// Body: { customer_name, customer_email, customer_address, items: [{ product_id, quantity }] }
// POST /api/orders
// Body: { customer_name, customer_email, customer_address, items: [{ product_id, quantity }] }
app.post('/api/orders', async (req, res) => {
    const client = await pool.connect();
    try {
        const { customer_name, customer_email, customer_address, items } = req.body;
        if (!customer_name || !customer_email || !items || !items.length) {
            return res.status(400).json({ error: 'Missing required fields' });
        }

        // Start transaction
        await client.query('BEGIN');

        // Calculate total and fetch product details for email
        let total_cents = 0;
        const itemsForEmail = [];
        for (const item of items) {
            const prodRes = await client.query('SELECT price_cents, name FROM products WHERE id = $1', [item.product_id]);
            if (prodRes.rows.length === 0) {
                await client.query('ROLLBACK');
                return res.status(400).json({ error: `Product ${item.product_id} not found` });
            }
            const price = prodRes.rows[0].price_cents;
            const name = prodRes.rows[0].name;
            total_cents += price * item.quantity;
            itemsForEmail.push({
                product_id: item.product_id,
                name: name,
                quantity: item.quantity,
                price_cents_at_time: price
            });
        }

        // Insert order
        const orderRes = await client.query(
            `INSERT INTO orders (customer_name, customer_email, customer_address, total_cents)
       VALUES ($1, $2, $3, $4) RETURNING id`,
            [customer_name, customer_email, customer_address, total_cents]
        );
        const orderId = orderRes.rows[0].id;

        // Insert order items
        for (const item of itemsForEmail) {
            await client.query(
                `INSERT INTO order_items (order_id, product_id, quantity, price_cents_at_time)
         VALUES ($1, $2, $3, $4)`,
                [orderId, item.product_id, item.quantity, item.price_cents_at_time]
            );
        }

        // Generate token for public order view
        const tokenRes = await client.query(
            `INSERT INTO order_tokens (order_id) VALUES ($1) RETURNING token`,
            [orderId]
        );
        const token = tokenRes.rows[0].token;

        // Commit transaction
        await client.query('COMMIT');

        // --- Send confirmation email (asynchronously, don't await) ---
        if (emailTransporter) {
            const emailData = {
                customer_name: customer_name,
                orderId: orderId,
                items: itemsForEmail,
                total_cents: total_cents,
                token: token
            };
            const emailHtml = generateOrderEmailHtml(emailData);
            const mailOptions = {
                from: '"Vida Luna" <cesar.beloca@tutanota.com>',
                to: customer_email,
                subject: `Your Vida Luna Order Confirmation (#${orderId})`,
                html: emailHtml,
                text: `Thank you for your order, ${customer_name}! Order #${orderId}. Total: Kč ${(total_cents/100).toFixed(2)}. Track: http://localhost:5000/api/orders/${token}`
            };
            emailTransporter.sendMail(mailOptions)
                .then(() => console.log(`✅ Order confirmation email sent to ${customer_email}`))
                .catch(err => console.error(`❌ Email failed for ${customer_email}:`, err));
        } else {
            console.warn(`⚠️ Email not sent – transporter missing for order ${orderId}`);
        }

        // Respond to client
        res.status(201).json({
            order_id: orderId,
            token: token,
            total_cents,
            message: 'Order created. A confirmation email has been sent to your address.'
        });

    } catch (err) {
        await client.query('ROLLBACK');
        console.error('Order creation error:', err);
        res.status(500).json({ error: err.message });
    } finally {
        client.release();
    }
});

// GET /api/orders/:token - public order lookup
app.get('/api/orders/:token', async (req, res) => {
    const {token} = req.params;
    try {
        const tokenRes = await pool.query(`SELECT order_id
                                           FROM order_tokens
                                           WHERE token = $1`, [token]);
        if (tokenRes.rows.length === 0) {
            return res.status(404).json({error: 'Order not found'});
        }
        const orderId = tokenRes.rows[0].order_id;

        const orderRes = await pool.query(`SELECT *
                                           FROM orders
                                           WHERE id = $1`, [orderId]);
        const order = orderRes.rows[0];

        const itemsRes = await pool.query(`SELECT oi.*, p.name, p.slug
                                           FROM order_items oi
                                                    JOIN products p ON oi.product_id = p.id
                                           WHERE oi.order_id = $1`, [orderId]);
        order.items = itemsRes.rows;

        res.json(order);
    } catch (err) {
        console.error(err);
        res.status(500).json({error: err.message});
    }
});

app.listen(port, () => {
    console.log(`Vida Luna backend running on port ${port}`);
});