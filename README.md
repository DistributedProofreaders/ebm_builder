# ebookmaker builder

> [!WARNING]
> This repo is **no longer being actively maintained**, since it was merely
> a support for [Guiguts version 1](https://github.com/DistributedProofreaders/guiguts).

This is a hacky little repo used to build Windows binaries for
[ebookmaker](https://github.com/gutenbergtools/ebookmaker) using
[pyinstaller](https://github.com/pyinstaller/pyinstaller).

These instructions use bash-isms and thus assume you are running the
following commands in a git bash shell on Windows (presumably after having
installed [Git for Windows](https://git-scm.com/download/win)).

## Set up build environment

1. Clone this repository

2. Install the ebookmaker build dependencies
   1. Install Python 3.10 from [python.org](https://www.python.org/downloads/windows/).
   2. Install Microsoft Visual Studio Build Tools.
      1. Go to [Microsoft Visual Studio Downloads](https://visualstudio.microsoft.com/downloads/).
      2. Scroll down and expand *Visual Studio* under *All Downloads*.
      3. Download *Build Tools for Visual Studio 2022*. This will download and
         start the Visual Studio Installer.
      4. In the installer, select the **Desktop Development with C++** workload. You really
         will need all of the things this wants to install by default. All 6GB of it.
      5. Start the install.

3. If not present already, you may need to add the following to your
   PATH to pick up python, pip, and pipenv:
   * `%USERPROFILE%\AppData\Local\Programs\Python\Python310`
   * `%USERPROFILE%\AppData\Local\Programs\Python\Python310\Scripts`
   * `%USERPROFILE%\AppData\Roaming\Python\Python310\Scripts`

4. Install `pipenv`
   ```
   pip install --user pipenv
   ```

5. Within the repository clone, install the pipenv virtual environment
   ```
   pipenv install
   ```

## Build ebookmaker

ebookmaker dynamically loads the set of available parsers, packagers,
and writers from the filesystem using `pkg_resources`. Unfortunately
this does not work with pyinstaller so we need to adjust the installed
ebookmaker code to provide it with an explicit list using the
`ebookmaker-pyinstaller.patch` file.

```bash
# Start a pipenv shell
pipenv shell

# Apply the patch
./apply_patch.sh
```

Create the ebookmaker binary with pyinstaller:

```bash
# Start a pipenv shell if you are not already
pipenv shell

# Run the installer
pyinstaller -F \
   --hidden-import ebookmaker.parsers.AuxParser \
   --hidden-import ebookmaker.parsers.CSSParser \
   --hidden-import ebookmaker.parsers.GutenbergTextParser \
   --hidden-import ebookmaker.parsers.HTMLParser \
   --hidden-import ebookmaker.parsers.ImageParser \
   --hidden-import ebookmaker.parsers.RSTParser \
   --hidden-import ebookmaker.parsers.WrapperParser \
   --hidden-import ebookmaker.writers.EpubWriter \
   --hidden-import ebookmaker.writers.Epub3Writer \
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
    --config-dir dist \
    --title sample_ebook \
    sample_ebook/ebmtest.htm
```

This should create `build/sample_ebook-images-epub.epub`.

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
4. Create the `ebookmaker.exe` file in the dist folder.
5. Create a zip named with the version of EBookMaker that it was built from.
   For example: `ebookmaker-0.9.1.zip`.
   It should contain the `ebookmaker.exe` file.
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

To update the version of ebookmaker this tool builds, install a new
version of the ebookmaker package with `pipenv install`:

```
pipenv install "ebookmaker==0.9.2"
```

Then re-apply the patch to enable building with pyinstaller and build
the new binary as instructed above. Depending on the changes within
ebookmaker this may require updating the patch and/or the list of hidden
imports passed into pyinstaller.

Be sure and check in the updated `Pipfile` and `Pipfile.lock` along with
any other changes before tagging and releasing a new binary.

## Troubleshooting

If ebookmaker crashes and the traceback refers to imported packages, it
may be that one of the packages has been updated, requiring an updated
version of pyinstaller. Try upgrading to the latest version of PyInstaller
by finding the [latest released version](https://github.com/pyinstaller/pyinstaller/releases)
and upgrading to it with:
```
pipenv install "pyinstaller==$LATEST_RELEASE"
```

An error such as `local variable 'xxxx' referenced before assignment` may
indicate that a fix is needed in ebookmaker itself. Contact the ebookmaker
maintainers with details.
