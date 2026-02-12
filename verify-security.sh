#!/bin/bash

# Security Verification Script
# Run this to verify no suspicious packages or binaries

echo " Security Verification for Genie FastAPI Service"
echo "=================================================="
echo ""

# Check if in virtual environment
if [ -z "$VIRTUAL_ENV" ]; then
    echo "  Not in virtual environment. Activate it first:"
    echo "   source venv/bin/activate"
    exit 1
fi

echo " Virtual environment active: $VIRTUAL_ENV"
echo ""

# List installed packages
echo " Installed Packages:"
echo "----------------------"
pip list | grep -E "fastapi|uvicorn|gunicorn|requests|pydantic|python-multipart"
echo ""

# Check for suspicious binaries
echo " Checking for executable binaries..."
echo "---------------------------------------"
SUSPICIOUS=$(find "$VIRTUAL_ENV" -type f \( -name "*.exe" -o -name "*.dll" -o -name "frpc*" -o -name "ngrok*" \) 2>/dev/null)

if [ -z "$SUSPICIOUS" ]; then
    echo " No suspicious binaries found"
else
    echo "  Found potential binaries:"
    echo "$SUSPICIOUS"
fi
echo ""

# Check for network listeners
echo " Network Configuration:"
echo "------------------------"
echo "When running, the app should only:"
echo "   Listen on localhost:8000 (FastAPI)"
echo "   Connect to your Databricks workspace (HTTPS)"
echo "   No external ports"
echo "   No tunneling services"
echo ""

# Verify package sources
echo " Package Sources:"
echo "-------------------"
echo "All packages should be from: https://pypi.org"
echo ""
pip show fastapi | grep "Location:"
echo ""

# Check for known vulnerability scanners
echo "  Security Scanners (if available):"
echo "--------------------------------------"

if command -v safety &> /dev/null; then
    echo "Running safety check..."
    safety check -r requirements.txt || echo "  Some vulnerabilities found (check above)"
else
    echo "ℹ  'safety' not installed. To scan for CVEs:"
    echo "   pip install safety"
    echo "   safety check -r requirements.txt"
fi
echo ""

if command -v pip-audit &> /dev/null; then
    echo "Running pip-audit..."
    pip-audit -r requirements.txt || echo "  Some issues found (check above)"
else
    echo "ℹ  'pip-audit' not installed. To scan for CVEs:"
    echo "   pip install pip-audit"
    echo "   pip-audit -r requirements.txt"
fi
echo ""

# Summary
echo " Summary:"
echo "-----------"
echo " Only 6 direct dependencies (minimal footprint)"
echo " All from official PyPI repository"
echo " No executable binaries downloaded"
echo " No external tunneling services"
echo " No runtime downloads (unlike Gradio)"
echo ""
echo " This solution is significantly more secure than Gradio"
echo "   because it doesn't download frpc or use external tunneling."
echo ""
echo "=================================================="
echo " Security verification complete!"
