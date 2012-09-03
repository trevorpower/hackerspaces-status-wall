module.exports = [
  { create: 'directories', capped: true, size: 10000000 }
  { create: 'spaces', capped: true, size: 80000000 }
  { create: 'tweeps', capped: true, size: 5000000 }
  { create: 'tweets', capped: true, size: 1000000 }
]
