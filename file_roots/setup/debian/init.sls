# Import base config
{% import "setup/debian/map.jinja" as build_cfg %}

build_pkgs:
  pkg.installed:
    - pkgs:
      - build-essential
      - devscripts
      - dh-exec
      - dh-make
      - fakeroot
      - debootstrap
      - pbuilder
      - reprepro
      - git
      - debhelper
      - gnupg
{% if build_cfg.build_release == 'debian9' %}
      - gnupg-agent
{% else %}
      - gpg-agent
{% endif%}
      - pkg-config
      - ccache
      - nfs-common
      - bash-completion


{{build_cfg.build_runas}}:
  user.present:
    - groups:
      - adm
    - require:
      - pkg: build_pkgs


build_cache_result_clean:
  file.absent:
    - name: /var/cache/pbuilder/result


build_cache_result_dir:
  file.directory:
    - name: /var/cache/pbuilder/result
    - user: {{build_cfg.build_runas}}
    - group: {{build_cfg.build_runas}}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
        - user
        - group
        - mode
    - require:
      - file: build_cache_result_clean


ensure_build_dest_dir:
  file.directory:
    - name: {{build_cfg.build_dest_dir}}
    - user: {{build_cfg.build_runas}}
    - group: {{build_cfg.build_runas}}
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
    - recurse:
        - user
        - group
        - mode

