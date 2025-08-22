{ ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    devices = {
      "uartpc" = {
        id = "CY5YEK2-BCLLIQI-2S7RDTQ-5UTH7TW-OSH57RK-HZ46Q5D-ANJD4RI-B24PKAY";
      };
      "pixel" = {
        id = "YOABTVV-RXHTLM2-SVLE6OG-DXOYLFE-ZQ7LVGR-3SCXZDF-D7EUTKZ-2PHQ3QI";
      };
      "owlbear" = {
        id = "2HPWTOS-4CFTD67-5FBDEDY-36LHYLC-E7NN3SL-2EH5TRP-5M6V6JA-ZOO5BAW";
      };
      "pixel9" = {
        id = "5RPMMEI-7VUROSB-PJNTON5-4VM5XOG-SW6QLS2-HFUSBHB-OF3AWE7-NKTJ4AD";
      };
    };
  };
}
