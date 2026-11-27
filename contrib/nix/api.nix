{
  lib,
  buildNpmPackage,
  nodejs_26,
  makeWrapper,
  importNpmLock,
  version,
}:

buildNpmPackage rec {
  pname = "gymbuddy-api";
  inherit version;

  src = ./../../api;

  nodejs = nodejs_26;

  npmDeps = importNpmLock { npmRoot = src; };
  npmConfigHook = importNpmLock.npmConfigHook;

  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/gymbuddy-api
    cp -r node_modules $out/lib/gymbuddy-api/
    cp -r coach $out/lib/gymbuddy-api/
    # Every top-level module server.js imports: server.js, password.js, passkeys-store.js,
    # rate-limit.js, media.js, device-link.js, push-messages.js, verify-error.js. Copy the
    # glob rather than an explicit list — a hand-kept list silently ships an incomplete tree
    # and the failure only shows up as ERR_MODULE_NOT_FOUND in the systemd journal.
    cp ./*.js $out/lib/gymbuddy-api/

    mkdir -p $out/bin
    makeWrapper ${nodejs_26}/bin/node $out/bin/gymbuddy-api \
      --add-flags "$out/lib/gymbuddy-api/server.js" \
      --set NODE_ENV production
    runHook postInstall
  '';

  meta = with lib; {
    description = "GYM Buddy API — passkey auth + per-user workout data (Node.js)";
    homepage = "https://gitlab.com/DuarteSantos8/gymbuddy";
    license = licenses.agpl3Plus;
    platforms = nodejs.meta.platforms;
  };
}
