#!/usr/bin/env bash
#
# Run jekyll serve and then launch the site

# Ensure Ruby 3.2 is in PATH
export PATH="/usr/local/opt/ruby@3.2/bin:$PATH"

# --incremental: 변경된 파일만 다시 빌드하여 속도 향상
# --livereload: 자동 새로고침
bundle exec jekyll s -H 0.0.0.0 -l --incremental
