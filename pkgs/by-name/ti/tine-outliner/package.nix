{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  libx11,
  libayatana-appindicator,
  dbus,
  glib,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  wrapGAppsHook3,
  gst_all_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tine-outliner";
  version = "0.8.1";

  buildFeatures = [ "custom-protocol" ];
  doCheck = false;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "martinkoutecky";
    repo = "tine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3AsEly5WfHlexYOIgzjbX9Hod0giJMJSITOAX04wzHw=";
  };

  cargoHash = "sha256-UYndUKXxeDL9mmFMZ3UbNoBVPiJ64/JycZtsqvnAXwE=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-DwRi0JBBOTq2br5PGhbNvpHJXnV+zeHDUjsqSDhriNc=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = with gst_all_1; [
    libx11
    dbus
    glib
    gtk3
    libsoup_3
    webkitgtk_4_1
    gstreamer
    gst-plugins-base
    gst-plugins-good
    libayatana-appindicator
  ];

  buildAndTestSubdir = "src-tauri";

  tauriBuildFlags = [
    "--features"
    "custom-protocol"
    "--config"
    (builtins.toJSON { bundle.createUpdaterArtifacts = false; })
  ];

  meta = {
    description = "Fast, local, Logseq-compatible outliner";
    homepage = "https://github.com/martinkoutecky/tine";
    license = lib.licenses.agpl3Only;
    mainProgram = "tine";
    maintainers = with lib.maintainers; [
      fcosanabria
      georgkrause
    ];
    platforms = lib.platforms.linux;
  };
})
