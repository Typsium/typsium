---
name: Bug report
about: Create a report to help us improve
title: "[Bug]"
labels: bug
assignees: tryptophawa
body:
  - type: textarea
    id: description
    attributes:
      label: Describe the bug
      placeholder: Tell us what happened!
    validations:
      required: true
  - type: textarea
    id: reproduce
    attributes:
      label: Share some code snippets so we can reproduce the situation.
      placeholder: ```typst #ce("some code")```
      render:typst
  - type: dropdown
    id: typst-version
    attributes:
      label: Typst Version
      description: On what version of Typst are you experiencing the issue?
      options:
        - latest
        - 0.13.1
        - 0.13.0
        - 0.12.x
        - earlier
      default: 0
    validations:
      required: true
  - type: dropdown
    id: typsium-version
    attributes:
      label: Typsium Version
      description: On what version of Typsium are you experiencing the issue?
      options:
        - latest
        - 0.2.0
        - 0.1.0
---
