{ stdenv, fetchFromGitHub, runCommand, python3, libargon2 }:

let
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dex6";
    repo = "sed-opal-unlocker";
    rev = "v${version}";
    sha256 = "0gr94jlw8d01a1bz2x6jhwim2hh4rijlj94x2fqxxhk22lbk61n2";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/dex6/sed-opal-unlocker";
    license = licenses.asl20;
    maintainers = [ maintainers.tadfisher ];
    platforms = platforms.linux;
  };

  sedutil-passhasher = stdenv.mkDerivation {
    inherit version src;
    name = "sedutil-passhasher";

    buildInputs = [ libargon2 python3 ];

    installPhase = ''
      mkdir -p $out/bin
      cp sedutil-passhasher.py $out/bin/sedutil-passhasher
    '';
  };

  sed-opal-unlocker = stdenv.mkDerivation {
    inherit version src;
    name = "sed-opal-unlocker";

    buildInputs = [ libargon2 ];

    passthru = {
      inherit sedutil-passhasher;
    };

    installPhase = ''
      mkdir -p $out/bin
      cp sed-opal-unlocker $out/bin
    '';
  };

in sed-opal-unlocker
