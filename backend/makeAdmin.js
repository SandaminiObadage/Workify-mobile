/**
 * Admin Setup Script
 * 
 * This script allows you to promote a user to admin status
 * 
 * Usage:
 *   node makeAdmin.js email@example.com
 */

const mongoose = require('mongoose');
require('dotenv').config();
const User = require('./models/User');

async function makeAdmin(email) {
    try {
        // Connect to database
        await mongoose.connect(process.env.MONGO_URL);
        console.log('Connected to database');

        // Find user by email
        const user = await User.findOne({ email: email });

        if (!user) {
            console.error(`User with email '${email}' not found`);
            process.exit(1);
        }

        // Update user to admin
        user.isAdmin = true;
        await user.save();

        console.log(`\n✓ Success! User '${user.username}' (${user.email}) is now an admin.`);
        console.log('\nAdmin Details:');
        console.log('- Username:', user.username);
        console.log('- Email:', user.email);
        console.log('- Is Admin:', user.isAdmin);
        console.log('- Is Agent:', user.isAgent);

        process.exit(0);
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

async function removeAdmin(email) {
    try {
        // Connect to database
        await mongoose.connect(process.env.MONGO_URL);
        console.log('Connected to database');

        // Find user by email
        const user = await User.findOne({ email: email });

        if (!user) {
            console.error(`User with email '${email}' not found`);
            process.exit(1);
        }

        // Remove admin status
        user.isAdmin = false;
        await user.save();

        console.log(`\n✓ Admin status removed from '${user.username}' (${user.email})`);

        process.exit(0);
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

async function listAdmins() {
    try {
        // Connect to database
        await mongoose.connect(process.env.MONGO_URL);
        console.log('Connected to database');

        // Find all admins
        const admins = await User.find({ isAdmin: true }, { password: 0 });

        if (admins.length === 0) {
            console.log('\nNo admin users found.');
        } else {
            console.log(`\nFound ${admins.length} admin user(s):\n`);
            admins.forEach((admin, index) => {
                console.log(`${index + 1}. ${admin.username} (${admin.email})`);
                console.log(`   - Is Agent: ${admin.isAgent}`);
                console.log(`   - Created: ${admin.createdAt}`);
                console.log('');
            });
        }

        process.exit(0);
    } catch (error) {
        console.error('Error:', error.message);
        process.exit(1);
    }
}

// Parse command line arguments
const args = process.argv.slice(2);
const command = args[0];
const email = args[1];

if (!command) {
    console.log('Admin Management Script\n');
    console.log('Usage:');
    console.log('  node makeAdmin.js add <email>       - Make a user admin');
    console.log('  node makeAdmin.js remove <email>    - Remove admin status');
    console.log('  node makeAdmin.js list              - List all admins');
    console.log('\nExamples:');
    console.log('  node makeAdmin.js add admin@example.com');
    console.log('  node makeAdmin.js remove admin@example.com');
    console.log('  node makeAdmin.js list');
    process.exit(0);
}

switch (command.toLowerCase()) {
    case 'add':
        if (!email) {
            console.error('Error: Email is required');
            console.log('Usage: node makeAdmin.js add <email>');
            process.exit(1);
        }
        makeAdmin(email);
        break;
    
    case 'remove':
        if (!email) {
            console.error('Error: Email is required');
            console.log('Usage: node makeAdmin.js remove <email>');
            process.exit(1);
        }
        removeAdmin(email);
        break;
    
    case 'list':
        listAdmins();
        break;
    
    default:
        console.error(`Unknown command: ${command}`);
        console.log('Valid commands: add, remove, list');
        process.exit(1);
}
