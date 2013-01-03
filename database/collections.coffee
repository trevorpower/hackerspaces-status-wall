module.exports = [
  { create: 'spaces' }
  { create: 'tweets', capped: true, size: 1000000 }
]
