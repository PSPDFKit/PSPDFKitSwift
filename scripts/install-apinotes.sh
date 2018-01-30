#!/usr/bin/bash

CURRENT_PWD="$PWD"
PROJECT_DIR=`cd "../../"; pwd`
cd "$CURRENT_PWD"


cp "$PROJECT_DIR/PSPDFKit.apinotes" "$CURRENT_PWD/PSPDFKit.framework/Headers/"