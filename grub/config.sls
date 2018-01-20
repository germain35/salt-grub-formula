{%- from "grub/map.jinja" import grub with context %}

include:
  - grub.install

{%- for k, v in grub.default.get('present', {}).iteritems() %}
grub_default_{{k}}:
  file.replace:
    - name: {{ grub.default_file }}
    - pattern: ^{{k}}=.*$
    {%- if v is list %}
    - repl: {{k}}="{{v|join(' ')}}"
    {%- else %}
    - repl: {{k}}={{v}}
    {%- endif %}
    - append_if_not_found: True
    - watch_in:
      - cmd: grub_update
{%- endfor %}

{%- for param in grub.default.get('abesent', []) %}
grub_default_{{param}}_absent:
  file.line:
    - match: ^{{param}}=.*$
    - mode: delete
    - watch_in:
      - cmd: grub_update
{%- endfor %}

{%- if grub.disable_messages %}
grub_diable_messages:
  file.comment:
    - name: {{ grub.linux_conf_file }}
    - regex: '^.*echo \"\$message\".*'
    - watch_in:
      - cmd: grub_update
{%- endif %}

grub_update:
  cmd.wait:
    - name: update-grub

