const dotenv = require('dotenv');

dotenv.config();

module.exports.PORT = process.env.PORT || 5000;
module.exports.DB_USER = process.env.DB_USER || 'Vasquez';
module.exports.DB_PASSWORD = process.env.DB_PASSWORD || 'MVasquez#19';
module.exports.DB_HOST = process.env.DB_HOST || 'localhost';
module.exports.DB_DATABASE = process.env.DB_DATABASE || 'cticsac';
module.exports.DB_PORT = process.env.DB_PORT || 3306;

