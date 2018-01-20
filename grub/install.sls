{%- from "grub/map.jinja" import grub with context %}

grub_pkgs:
  pkg.installed:
    - pkgs: {{grub.pkgs}}

