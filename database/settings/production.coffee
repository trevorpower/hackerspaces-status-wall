module.exports =
  name: 'hackerspaces-me'
  host: process.env.MONGO_HOST
  port: parseInt process.env.MONGO_PORT
  user: process.env.MONGO_USER
  password: process.env.MONGO_PASSWORD
