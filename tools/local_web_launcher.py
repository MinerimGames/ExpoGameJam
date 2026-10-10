"""Start the delivered game server before opening the browser."""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import webbrowser


class GameServer(ThreadingHTTPServer):
    request_queue_size = 64


def main():
    web_folder = Path(__file__).resolve().parent / 'Web'
    if not (web_folder / 'index.html').is_file():
        raise SystemExit('A pasta Web deve permanecer junto deste lançador.')
    handler = partial(SimpleHTTPRequestHandler, directory=str(web_folder))
    try:
        server = GameServer(('127.0.0.1', 8319), handler)
    except OSError:
        raise SystemExit('A porta 8319 está ocupada. Feche o servidor anterior e tente novamente.')
    url = 'http://localhost:8319/'
    print(f'Jogo disponível em {url}\nMantenha esta janela aberta. Para encerrar, pressione Ctrl+C.')
    webbrowser.open(url)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == '__main__':
    main()
