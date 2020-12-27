# ebookmaker builder

This is a hacky little repo used to build Windows binaries for
[ebookmaker](https://github.com/gutenbergtools/ebookmaker) using
[pyinstaller](https://github.com/pyinstaller/pyinstaller).

These instructions use bash-isms and thus assume you are running the
following commands in a git bash shell on Windows (presumably after having
installed [Git for Windows](https://git-scm.com/download/win)).

## Set up build environment

1. Clone this repository

2. Install the ebookmaker build dependencies
   1. Install Python 3.8 from [python.org](https://www.python.org/downloads/windows/).
   2. Install Microsoft Visual Studio Build Tools.
      1. Go to [Microsoft Visual Studio Downloads](https://visualstudio.microsoft.com/downloads/).
      2. Scroll down and expand *Tools for Visual Studio 2019*.
      3. Download *Build Tools for Visual Studio 2019*. This will download and
         start the Visual Studio Installer.
      4. In the installer, select the **C++ build tools** workload. You really
         will need all of the things this wants to install. All 4GB of it.
      5. Start the install.

3. Install `pipenv`
   ```
   pip install --user pipenv
   ```

4. Within the repository clone, install the pipenv virtual environment
   ```
   pipenv install
   ```

5. Enter into a pipenv shell
   ```
   pipenv shell
   ```

## Build ebookmaker

Create the ebookmaker binary with pyinstaller:

```
pyinstaller -F \
   --hidden-import ebookmaker.parsers.AuxParser \
   --hidden-import ebookmaker.parsers.CSSParser \
   --hidden-import ebookmaker.parsers.GutenbergTextParser \
   --hidden-import ebookmaker.parsers.HTMLParser \
   --hidden-import ebookmaker.parsers.ImageParser \
   --hidden-import ebookmaker.parsers.RSTParser \
   --hidden-import ebookmaker.parsers.WrapperParser \
   --hidden-import ebookmaker.writers.EpubWriter \
   --hidden-import ebookmaker.writers.HTMLWriter \
   --hidden-import ebookmaker.writers.KindleWriter \
   --hidden-import ebookmaker.writers.PDFWriter \
   --hidden-import ebookmaker.writers.PicsDirWriter \
   --hidden-import ebookmaker.writers.RSTWriter \
   --hidden-import ebookmaker.writers.TxtWriter \
   --hidden-import ebookmaker.packagers.GzipPackager \
   --hidden-import ebookmaker.packagers.HTMLPackager \
   --hidden-import ebookmaker.packagers.PDFPackager \
   --hidden-import ebookmaker.packagers.PushPackager \
   --hidden-import ebookmaker.packagers.RSTPackager \
   --hidden-import ebookmaker.packagers.TxtPackager \
   "$(which ebookmaker)"
```

This will create the Windows binary `dist/ebookmaker.exe`.

## Validate binary

To validate the `ebookmaker.exe` binary is working correctly, you must
build an epub, not just `ebookmaker.exe --version`:

```bash
./dist/ebookmaker.exe \
    --verbose \
    --make=epub.images \
    --output-dir build \
    --title sample_ebook \
    sample_ebook/ebmtest.htm
```

This should create `build/sample_ebook-images-epub.epub`. You may get an
error if `tidy` isn't installed on your system -- this is fine and can
be ignored.

## Releasing binaries

To release a new binary:

1. Ensure you are working with a fresh checkout of the `master` branch.
2. Tag the repo with the same version of EBookMaker installed in the `Pipfile`:
   ```
   git tag v0.9.1 master
   ```
3. Push the tag to the upstream repo:
   ```
   git push --tags upstream
   ```
4. Create the `ebookmaker.exe` file.
5. Create a zip of the `ebookmaker.exe` file named with the version of
   EBookMaker that it was built from. For example: `ebookmaker-0.9.1.zip`.
6. Create an [ebm_builder release](https://github.com/DistributedProofreaders/ebm_builder/releases)
   with the tag using the following template:
   * Release title: <tag name>
   * Description: _updated with the appropriate versions_
     ```
     This is a Windows binary of the <tagname>
     [ebookmaker](https://github.com/gutenbergtools/ebookmaker) tool built on
     Windows 10 with pyinstaller and Python 3.8.
     ```
   * Attach the zip file

## Updating the version of ebookmaker

To update the version of ebookmaker this tool builds you will need to
`pipenv install` the newer ebookmaker package version. You may (or may not)
need to also adjust the version of pyinstaller or any of the other magical
package dependencies specified inside the Pipfile.

For example:
```
pipenv install "ebookmaker==0.9.2"
```
