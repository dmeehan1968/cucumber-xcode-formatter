Cucumber Xcode Formatter
========================

This is a custom formatter plugin for [Cucumber](https://github.com/cucumber/cucumber).

The purpose of the plugin is to change the Cucumber output so that it emits step definition problems in a format suitable for Xcode to interpret them as build errors and warnings so that they appear in the Issues Navigator, and allow issue to link to the relevant source files (.features etc) for quick navigation.

I've found this particularly useful when working with [cucumber-cpp](https://github.com/cucumber/cucumber-cpp) to develop C++ applications in Xcode.

Installation
============

The only required file is [features/support/xcode_formatter.rb](https://github.com/dmeehan1968/cucumber-xcode-formatter/blob/master/features/support/xcode_formatter.rb).  You should create a support folder within your features folder, and copy place xcode_formatter.rb there.

    /features
        <your features>
        /step_definitions
            <your step definitions>
        /support
            xcode_formatter.rb

Usage
=====

In Xcode, you will have a target for the step_definitions (for example in .cpp files compatible with cucumber-cpp).  

1. Highlight the Project in the Project Navigator
2. Highlight the Build Target that includes your step definitions
3. Choose Build Phases
4. Add a New Run Script Phase
5. Set the Shell to /bin/sh
6. Add the following lines as the script:

```bash
    ${BUILT_PRODUCTS_DIR}/"${PRODUCT_NAME}" &
    ps cax | grep "${PRODUCT_NAME}" > /dev/null
    if [ $? -eq 0 ]; then
        cucumber --no-snippets --strict --format Cucumber::Formatter::Xcode
    fi
```

When the product is built, assuming the main target builds successfully, the script will run the test target in the background so that it acts as a wire server, and then run Cucumber to get the step results.

If all cucumber steps pass, there is no output and cucumber exits with 0, indicating success.

If any cucumber steps fail, are skipped or undefined, the formatter will produce output so that failing tests are treated by Xcode as errors, and skipped or undefined steps are treated as warnings.

You should see issues in the Issues Navigator for each error or warning, with links to both the line in the .feature file and in the step_definitions source file.

Feedback
========

Please create [Github Issues](https://github.com/dmeehan1968/cucumber-xcode-formatter/issues) for any problems or queries that you have.