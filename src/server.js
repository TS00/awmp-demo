// AWMP Demo: Chaos Health Endpoint
// Simple HTTP server with toggleable health status

const http = require('http');

const PORT = process.env.PORT || 3000;
const STATUS = process.env.CHAOS_HEALTH_STATUS || 'broken';

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    if (STATUS === 'healthy') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'ok', chaos: false }));
    } else {
      res.writeHead(500, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'error', chaos: true, message: 'Chaos: forced /health failure' }));
    }
  } else {
    res.writeHead(404);
    res.end('Not found');
  }
});

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Health status: ${STATUS}`);
  console.log(`Test: curl http://localhost:${PORT}/health`);
});
