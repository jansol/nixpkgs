{ lib, fetchPypi, buildPythonPackage, pip, pytest, click, six
, setuptools_scm, git, glibcLocales, mock }:

buildPythonPackage rec {
  pname = "pip-tools";
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4d3990df2d65961af8b41dacc242e600fdc8a65a2e155ed3d2fc18a5c209f20";
  };

  LC_ALL = "en_US.UTF-8";
  checkInputs = [ pytest git glibcLocales mock ];
  propagatedBuildInputs = [ pip click six setuptools_scm ];

  disabledTests = lib.concatMapStringsSep " and " (s: "not " + s) [
    # Depend on network tests:
    "test_allow_unsafe_option" #paramaterized, but all fail
    "test_annotate_option" #paramaterized, but all fail
    "test_editable_package_vcs"
    "test_editable_top_level_deps_preserved" # can't figure out how to select only one parameter to ignore
    "test_filter_pip_markers"
    "test_filter_pip_markes"
    "test_generate_hashes_all_platforms"
    "test_generate_hashes_verbose"
    "test_generate_hashes_with_editable"
    "test_generate_hashes_with_url"
    "test_generate_hashes_without_interfering_with_each_other"
    "test_get_file_hash_without_interfering_with_each_other"
    "test_get_hashes_local_repository_cache_miss"
    "test_realistic_complex_sub_dependencies"
    "test_stdin"
    "test_upgrade_packages_option"
    "test_url_package"
    "test_editable_package"
    "test_locally_available_editable_package_is_not_archived_in_cache_dir"
  ];

  checkPhase = ''
    export HOME=$(mktemp -d) VIRTUAL_ENV=1
    py.test -k "${disabledTests}"
  '';

  meta = with lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = "https://github.com/jazzband/pip-tools/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
