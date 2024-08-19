inherit allarch

SUMMARY = "SYS TEC version information"
DESCRIPTION = "Version information for SYS TEC sysWORXX devices"
LICENSE = "MIT"
INHIBIT_DEFAULT_DEPS = "1"

do_fetch[noexec] = "1"
do_unpack[noexec] = "1"
do_patch[noexec] = "1"
do_configure[noexec] = "1"

SYSTEC_VERSION_FIELDS = "GIT_TAG BUILD_HOST RELEASE_VERSION"

python do_compile () {
    import os
    from os import path
    import subprocess
    import re

    builddir = d.getVar('TOPDIR', True)
    results = {}
    args = {'stderr': subprocess.PIPE, 'stdout': subprocess.PIPE, 'check': True}

    try:
        os.chdir(os.getcwd() + '/..')
        git_tag = subprocess.run(['git', 'describe', '--tags'], **args)
    except subprocess.CalledProcessError as e:
        bb.warn("Failed to get tag information, falling back to git hash")
        bb.warn(str(e))
        bb.warn(e.stderr.decode())
        try:
            git_tag = subprocess.run(['git', 'rev-parse', 'HEAD'], **args)
        except subprocess.CalledProcessError as e:
            bb.warn("Failed to get information from git repository in: {}"
                    .format(builddir))
            bb.warn(str(e))
            bb.warn(e.stderr.decode())
            git_tag = "no git version information available"

    # matches e.g. "v0.0.1 (2020-12-01)"
    # group(1)      ^^^^^^
    regex = re.compile(r"^\s*(v\d+.\d+.\d+) \(\d+-\d+-\d+\)")
    release_notes = path.join(builddir, '../ReleaseNotes.md')
    versions = []
    try:
        with open(release_notes) as f:
            for line in f:
                match = regex.match(line)
                if match:
                    versions.append(match.group(1))
    except FileNotFoundError:
        bb.error("Failed to access file: {}".format(release_notes))
        raise
    if len(versions):
        # ReleaseNotes.md starts with the most current version, use index 0
        results['RELEASE_VERSION'] = versions[0]
    else:
        bb.error("Failed to get version information from file: {}"
            .format(release_notes))
        raise RuntimeError("Missing version information")

    results['GIT_TAG'] = git_tag
    results['BUILD_HOST'] = subprocess.run(['hostname'], **args)

    for name, out in results.items():
        if type(out) == subprocess.CompletedProcess:
            out = out.stdout.decode().strip()
        d.setVar(name, out)

    with open(d.expand('${B}/systec-version'), 'w') as f:
        for field in d.getVar('SYSTEC_VERSION_FIELDS').split():
            value = d.getVar(field)
            if value:
                f.write('{0}="{1}"\n'.format(field, value))
}
do_compile[vardeps] += "${SYSTEC_VERSION_FIELDS}"

do_install () {
    install -d ${D}${nonarch_libdir}
    install -m 0644 systec-version ${D}${nonarch_libdir}/
    install -d ${D}${sysconfdir}
    ln -rs ${D}${nonarch_libdir}/systec-version ${D}${sysconfdir}/systec-version
}

do_compile[nostamp]="1"

FILES:${PN} = "${sysconfdir}/systec-version ${nonarch_libdir}/systec-version"
