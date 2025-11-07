# 🤝 Contributing Guide

**Help improve the Manfree Nextcloud Platform**

---

## 📋 Ways to Contribute

### 1. Report Issues
- Bug reports
- Feature requests
- Documentation improvements
- Security vulnerabilities

### 2. Submit Code
- Bug fixes
- New features
- Performance improvements
- Documentation updates

### 3. Improve Documentation
- Fix typos
- Add examples
- Clarify instructions
- Translate content

---

## 🚀 Getting Started

### Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR-USERNAME/manfree-nextcloud-platforms.git
cd manfree-nextcloud-platforms
```

### Create Branch

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Or bug fix branch
git checkout -b fix/bug-description
```

### Make Changes

```bash
# Make your changes
# Test thoroughly
./up.sh

# Commit with clear message
git add .
git commit -m "Add: Brief description of changes"
```

### Submit Pull Request

```bash
# Push to your fork
git push origin feature/your-feature-name

# Create pull request on GitHub
# Describe your changes clearly
```

---

## 📝 Commit Message Guidelines

### Format

```
Type: Brief description (50 chars max)

Detailed explanation if needed (wrap at 72 chars)

- Bullet points for multiple changes
- Reference issues: Fixes #123
```

### Types

- **Add:** New feature or functionality
- **Fix:** Bug fix
- **Update:** Modify existing feature
- **Remove:** Delete code or feature
- **Docs:** Documentation changes
- **Style:** Code formatting (no logic change)
- **Refactor:** Code restructuring
- **Test:** Add or update tests
- **Chore:** Maintenance tasks

### Examples

```bash
# Good
git commit -m "Add: Cloudflare tunnel auto-start script"
git commit -m "Fix: Port binding issue in docker-compose.yml"
git commit -m "Docs: Update installation guide with troubleshooting"

# Bad
git commit -m "fixed stuff"
git commit -m "updates"
git commit -m "WIP"
```

---

## 🧪 Testing

### Before Submitting

```bash
# Test fresh installation
./down.sh
docker system prune -af
./up.sh

# Test backup/restore
./auto-backup.sh
./down.sh
./auto-restore.sh
./up.sh

# Test all scripts
chmod +x *.sh
./up.sh
./down.sh
```

### Checklist

- [ ] Code works on fresh installation
- [ ] No breaking changes to existing features
- [ ] Documentation updated
- [ ] Scripts are executable
- [ ] No sensitive data in commits
- [ ] Follows project structure

---

## 📚 Code Style

### Shell Scripts

```bash
#!/bin/bash
set -e

# Use descriptive variable names
BACKUP_DIR="./backup"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Add comments for complex logic
# This function creates a backup of all volumes
create_backup() {
    echo "Creating backup..."
    # Implementation
}

# Use proper error handling
if ! docker-compose ps; then
    echo "Error: Docker not running"
    exit 1
fi
```

### Docker Files

```dockerfile
# Use official base images
FROM nextcloud:latest

# Group related commands
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*

# Add comments for clarity
# Configure PHP for large file uploads
RUN echo 'upload_max_filesize=10G' > /usr/local/etc/php/conf.d/uploads.ini
```

### Documentation

```markdown
# Use clear headings

## Organize with subheadings

### Provide examples

\`\`\`bash
# Show actual commands
docker-compose up -d
\`\`\`

**Highlight important points**

- Use bullet points for lists
- Keep paragraphs short
- Add emojis for visual appeal ✨
```

---

## 🔍 Code Review Process

### What We Look For

1. **Functionality:** Does it work as intended?
2. **Quality:** Is the code clean and maintainable?
3. **Documentation:** Are changes documented?
4. **Testing:** Has it been tested?
5. **Security:** Are there security implications?

### Review Timeline

- Initial review: Within 48 hours
- Feedback provided: Within 1 week
- Merge decision: After all feedback addressed

---

## 🎯 Priority Areas

### High Priority

- Security improvements
- Bug fixes
- Performance optimization
- Documentation clarity

### Medium Priority

- New features
- UI/UX improvements
- Additional integrations
- Automation enhancements

### Low Priority

- Code refactoring
- Style improvements
- Minor optimizations

---

## 📞 Getting Help

### Questions?

- Open a discussion on GitHub
- Check existing issues
- Review documentation
- Contact maintainers

### Stuck?

- Describe what you're trying to do
- Share error messages
- Provide steps to reproduce
- Include system information

---

## 🏆 Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in documentation
- Appreciated by the community! 🎉

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

**Thank you for contributing!** 🙏

*Together we make this platform better for everyone.*
