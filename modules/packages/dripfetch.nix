{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication {
  pname = "dripfetch";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "a-shygun";
    repo = "dripfetch";
    rev = "d1971e7dce6b7ecee1f0c12fc6f6083a64111a3d";
    hash = "sha256-bwD7nJAj5dTyEwfV3yaPHS7NflQu+LYiwoaRTlm22lI=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    psutil
    ruamel-yaml
  ];

  pythonImportsCheck = [ "dripfetch" ];

  meta = {
    description = "Customizable terminal system information display with animated rain";
    homepage = "https://github.com/a-shygun/dripfetch";
    license = lib.licenses.mit;
    mainProgram = "dripfetch";
    platforms = lib.platforms.unix;
  };
}
