# Мамин дом

House manuals for Mom, published with GitHub Pages.

`index.html` is encrypted with [StatiCrypt](https://github.com/robinmoisson/staticrypt). The readable page and the password are not stored in this repo.

## Update the site

```bash
MOM_PASSWORD='…' ./build.sh /path/to/mamin-dom.html
git add index.html && git commit -m "Update manuals" && git push
```

Keep `.staticrypt.json` (the salt) unchanged, otherwise phones that ticked "remember me" will have to type the password again.

The site works offline (`sw.js`) and can be added to the home screen (`manifest.webmanifest`, `icon-*.png`).
