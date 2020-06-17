# ebookmaker builder

This is a hacky little repo used to build Windows binaries for
[ebookmaker](https://github.com/gutenbergtools/ebookmaker) using
[pyinstaller](https://github.com/pyinstaller/pyinstaller). It uses
an in-development version of pyinstaller to work around issues with
setuptools==45 and the lack of an installer hook for jaraco.text.

These instructions use bash-isms and thus assume you are running the
following commands in a git bash shell on Windows.

To use:

1. Clone this repository
2. Install the ebookmaker build dependencies
3. Create the pipenv virtual environment
   ```
   pipenv install
   ```
4. Enter into a pipenv shell
   ```
   pipenv shell
   ```
5. Build ebookmaker
   ```
   pyinstaller -F "$(which ebookmaker)"
   ```

This will create the Windows binary `dist/ebookmaker.exe`.


