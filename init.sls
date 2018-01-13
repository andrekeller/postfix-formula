{%- set postfix_type = salt['pillar.get']('postfix_type', 'client') %}
postfix:
  pkg.installed:
    - pkgs:
      - postfix
  service.running:
    - name: postfix.service
    - enable: True

postfix_aliases:
  file.managed:
    - name: /etc/postfix/aliases
    - source: salt://postfix/files/aliases
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  cmd.wait:
    - name: /usr/bin/newaliases
    - watch:
      - file: /etc/postfix/aliases

/etc/postfix/main.cf:
  file.managed:
    - source: salt://postfix/files/main.{{ postfix_type }}.cf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - service: postfix

/etc/postfix/master.cf:
  file.managed:
    - source: salt://postfix/files/master.{{ postfix_type }}.cf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: postfix

/etc/postfix/maps:
  file.directory:
    - user: root
    - group: root
    - mode: 755

{%- if postfix_type == 'mx' %}
/etc/postfix/maps/postscreen_access.cidr:
  file.managed:
    - source: salt://postfix/files/maps/postscreen_access.cidr
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
/etc/postfix/maps/sender_mx_access.cidr:
  file.managed:
    - source: salt://postfix/files/maps/sender_mx_access.cidr
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
/etc/postfix/maps/relay_domains.mysql:
  file.managed:
    - source: salt://postfix/files/maps/relay_domains.mysql
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
/etc/postfix/maps/relay_recipient_maps_aliases.mysql:
  file.managed:
    - source: salt://postfix/files/maps/relay_recipient_maps_aliases.mysql
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
/etc/postfix/maps/relay_recipient_maps_users.mysql:
  file.managed:
    - source: salt://postfix/files/maps/relay_recipient_maps_users.mysql
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
/etc/postfix/maps/transport.mysql:
  file.managed:
    - source: salt://postfix/files/maps/transport.mysql
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
{% elif postfix_type == 'backend' %}
/etc/postfix/maps/mx_access.cidr:
  file.managed:
    - source: salt://postfix/files/maps/mx_access.cidr
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
/etc/postfix/maps/virtual_alias_maps.mysql:
  file.managed:
    - source: salt://postfix/files/maps/virtual_alias_maps.mysql
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
/etc/postfix/maps/virtual_mailbox_maps.mysql:
  file.managed:
    - source: salt://postfix/files/maps/virtual_mailbox_maps.mysql
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
/etc/postfix/maps/virtual_mailbox_domains.mysql:
  file.managed:
    - source: salt://postfix/files/maps/virtual_mailbox_domains.mysql
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - file: /etc/postfix/maps
    - watch_in:
      - service: postfix
{%- endif %}
