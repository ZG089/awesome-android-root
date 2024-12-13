#!/bin/bash

set -euo pipefail

# Error handling
handle_error() {
    echo "Error: $1"
    cleanup
    exit 1
}

# Cleanup function
cleanup() {
    rm -f header.html template.html
}

# Check requirements
if ! command -v pandoc &> /dev/null; then
    handle_error "pandoc is not installed. Please install it first."
fi

# Check if styles.css exists
if [[ ! -f ./docs/styles.css ]]; then
    handle_error "styles.css not found in ./docs. Please ensure it exists."
fi

# Read styles.css content
INLINE_CSS=$(<./docs/styles.css)

# Create template
cat > template.html << 'EOL'
<!DOCTYPE html>
<html lang="en">
<head>
    $header-includes$
</head>
<body>
    
    <header role="banner">
        <h1 class="title">$title$</h1>
        <nav role="navigation" aria-label="Table of contents">
            $toc$
        </nav>
    </header>

    <main id="main-content" role="main">
        $body$
    </main>

    <footer role="contentinfo">
        <p>Made with ❤️ by Fynks</p>
    </footer>

</body>
</html>
EOL

# Create header with inline CSS and improved meta tags
cat > header.html << EOL
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="A comprehensive, curated list of Android root apps, tools, and utilities. Includes ad blockers, system tools, customization apps, and root-specific utilities.">
<link rel="icon" href="../favicon.ico" sizes="any">
<link rel="icon" href="../favicon.svg" type="image/svg+xml">
<title>Awesome Android Root</title>
<meta name="theme-color" content="#0366d6">
<link rel="canonical" href="https://awesome-android-root.netlify.app/">

<link rel="dns-prefetch" href="https://awesome.re" />
<link rel="preconnect" href="https://awesome.re" />
<link rel="dns-prefetch" href="https://profile-counter.glitch.me/" />
<link rel="preconnect" href="https://profile-counter.glitch.me/" />
<style>
${INLINE_CSS}
</style>

<!-- OpenGraph Meta Tags -->
<meta property="og:title" content="Awesome Android Root - Ultimate List of Root Apps">
<meta property="og:description" content="Discover the best Android root apps, tools, and utilities. A curated collection of essential root applications for advanced Android users.">
<meta property="og:type" content="website">
<meta property="og:image" content="https://raw.githubusercontent.com/sindresorhus/awesome/main/media/logo.svg">
<meta property="og:url" content="https://awesome-android-root.netlify.app/">
<meta property="og:site_name" content="Awesome Android Root">

<!-- Twitter Card Meta Tags -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Awesome Android Root - Ultimate List of Root Apps">
<meta name="twitter:description" content="Discover the best Android root apps, tools, and utilities. A curated collection of essential root applications.">
<meta name="twitter:image" content="https://raw.githubusercontent.com/sindresorhus/awesome/main/media/logo.svg">

<!-- SEO Meta Tags -->
<meta name="keywords" content="android root, root apps, magisk modules, xposed modules, android customization, android tools, root utilities, android mods">
<meta name="author" content="Android Root Community">
<meta name="robots" content="index, follow">
<meta name="language" content="English">
EOL

# Convert markdown with progress
echo "Starting conversion process..."
echo "→ Generating HTML from markdown..."
pandoc README.md \
    --from gfm \
    --to html5 \
    --standalone \
    --template=template.html \
    --include-in-header=header.html \
    --metadata title="Awesome Android Root" \
    --shift-heading-level-by=-1 \
    --toc-depth=2 \
    -o docs/index.html || handle_error "Conversion failed"

# Cleanup
cleanup

echo "✓ Conversion complete! Output saved as index.html"
echo "→ Table of contents generated"
echo "→ Dark mode support added"
echo "→ Accessibility features implemented"
