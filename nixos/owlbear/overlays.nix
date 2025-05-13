self: super: {
  libreoffice-qt6-fresh = super.libreoffice-qt6-fresh.overrideAttrs ( oldAttrs: {
    # nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ super.makeBinaryWrapper ];
    
    postInstall = (oldAttrs.postInstall or "") + ''
      wrapProgram $out/bin/libreoffice --set QT_QPA_PLATFORM xcb
      wrapProgram $out/bin/soffice --set QT_QPA_PLATFORM xcb
      wrapProgram $out/bin/sbase --set QT_QPA_PLATFORM xcb
      wrapProgram $out/bin/scalc --set QT_QPA_PLATFORM xcb
      wrapProgram $out/bin/sdraw --set QT_QPA_PLATFORM xcb
      wrapProgram $out/bin/simpress --set QT_QPA_PLATFORM xcb
      wrapProgram $out/bin/smath --set QT_QPA_PLATFORM xcb
      wrapProgram $out/bin/swriter --set QT_QPA_PLATFORM xcb
      wrapProgram $out/bin/unopkg --set QT_QPA_PLATFORM xcb
    '';
  }
  );
}
