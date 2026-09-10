"""Loopback-only static reviewer with deterministic MIME types on Windows."""
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
from functools import partial
import argparse

class Handler(SimpleHTTPRequestHandler):
    extensions_map = {**SimpleHTTPRequestHandler.extensions_map,
                      '.mjs': 'text/javascript', '.js': 'text/javascript',
                      '.css': 'text/css', '.html': 'text/html',
                      '.json': 'application/json', '.md': 'text/plain; charset=utf-8',
                      '.mbt': 'text/plain; charset=utf-8', '.mbti': 'text/plain; charset=utf-8'}

    def send_head(self):
        path = Path(self.translate_path(self.path))
        root = Path(self.directory).resolve()
        if any(part in {'.git', '_build', 'target', '.mooncakes'} for part in path.parts) or not path.resolve().is_relative_to(root):
            self.send_error(404)
            return None
        return super().send_head()

    def list_directory(self, path):
        self.send_error(404)
        return None

    def end_headers(self):
        self.send_header('Cache-Control', 'no-store')
        super().end_headers()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', type=int, default=8769)
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    server = ThreadingHTTPServer(('127.0.0.1', args.port), partial(Handler, directory=str(root)))
    print(f'Local review: http://127.0.0.1:{args.port}/web/', flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
