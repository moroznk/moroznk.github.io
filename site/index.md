---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

# Устройства

|| Устройство ||
|----|
{%- for post in site.posts -%}
| [{{ post.title | escape }}]({{ post.url | relative_url }}) |
{% endfor %}
