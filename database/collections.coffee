module.exports = [
  { create: 'spaces' }
  { create: 'tweets', capped: true, size: 1000000 }
  { create: 'events', capped: true, size: 1000000 }
]
