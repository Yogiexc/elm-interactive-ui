# Contributing to Elm Interactive UI

Terima kasih telah tertarik untuk berkontribusi! 🎉

## 🚀 Quick Start

1. Fork repository ini
2. Clone fork kamu:
   ```bash
   git clone https://github.com/yourusername/elm-interactive-ui.git
   ```
3. Install Elm:
   ```bash
   npm install -g elm
   ```
4. Buat branch baru:
   ```bash
   git checkout -b feature/amazing-feature
   ```

## 📝 Contribution Guidelines

### Areas to Contribute

1. **New Components**
   - Tambahkan komponen UI interaktif baru
   - Pastikan mengikuti Elm Architecture (MVU)
   - Dokumentasikan konsep functional yang digunakan

2. **Documentation**
   - Improve README
   - Add code comments
   - Create tutorials or examples

3. **Bug Fixes**
   - Fix any issues
   - Add tests if possible

4. **Styling**
   - Improve CSS
   - Make responsive design better
   - Add animations

### Code Style

```elm
-- Gunakan nama yang descriptive
type Msg
    = IncrementCounter
    | UpdateUserEmail String
    | SubmitForm

-- Always use type annotations
validateEmail : String -> Bool
validateEmail email =
    String.contains "@" email

-- Format code dengan elm-format
elm-format src/ --yes
```

### Commit Messages

Format:
```
feat: add color picker component
fix: resolve timer reset bug
docs: update installation guide
style: improve button hover effects
refactor: simplify validation logic
```

### Pull Request Process

1. Update README jika ada perubahan fitur
2. Pastikan code compile tanpa error:
   ```bash
   elm make src/Main.elm --output=elm.js
   ```
3. Test di browser
4. Submit PR dengan deskripsi yang jelas

## 🎯 What We're Looking For

### Component Ideas
- [ ] Dropdown Menu
- [ ] Modal/Dialog
- [ ] Tabs
- [ ] Carousel
- [ ] Tooltip
- [ ] Date Picker
- [ ] Chart/Graph
- [ ] Drag & Drop

### Advanced Features
- [ ] HTTP requests example
- [ ] JSON decoding
- [ ] LocalStorage integration (via Ports)
- [ ] Animation library integration
- [ ] Unit tests
- [ ] E2E tests

## 🤝 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn Elm
- Share knowledge generously

## 📚 Learning Resources

Jika kamu baru di Elm:
- [Official Elm Guide](https://guide.elm-lang.org/)
- [Elm in Action](https://www.manning.com/books/elm-in-action)
- [Elm Radio Podcast](https://elm-radio.com/)

## 💬 Questions?

- Open an issue dengan label `question`
- Join [Elm Slack](https://elmlang.herokuapp.com/)
- Tweet [@elmlang](https://twitter.com/elmlang)

---

**Thank you for making Elm Interactive UI better!** 🙏