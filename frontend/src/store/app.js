// Utilities
import { defineStore } from "pinia";
import $ from "jquery";
import crypter from "@/assets/crypter";
import Swal from "sweetalert2";

export const useAppStore = defineStore("app", {
  state: () => ({
    //
    preload: false,
    alert: Swal.mixin({
      toast: true,
      position: "top-end",
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
      didOpen: (toast) => {
        toast.onmouseenter = Swal.stopTimer;
        toast.onmouseleave = Swal.resumeTimer;
      },
      customClass: {
        container: "swal-custom-zindex", // Class kustom untuk elemen swal
      },
    }),
    alertData: {
      text: "",
      icon: "",
      color: "",
      title: "",
    },
    session: {
      auth: {
        token: null,
      },
      deviceInfo: {},
    },
    serverStatus: false,
    configs: {},
    // apiserver: "http://62.72.29.171:3001/",
    apiserver: `${import.meta.env.VITE_API_SERVER}:${import.meta.env.VITE_API_SERVER_PORT}/`,
  }),
  persist: {
    pick: ["session", "configs"],
  },
  actions: {
    ajaxPost(data) {
      const server = this.apiserver;
      return new Promise(function (resolve, reject) {
        const reqData = data.reqData;
        const hash = crypter.encryptObject(reqData);
        $.ajax({
          beforeSend: tooglePreload(),
          type: "POST",
          url: server + data.url,
          data: { hash },
          dataType: "json",
          success: function (response) {
            resolve(response);
            tooglePreload()
          },
          error: (error) => {
            reject(error.responseJSON.error);
            tooglePreload()
          },
        });
      });
    },
    ajaxPostWithFile(data) {
      const server = this.apiserver;
      return new Promise((resolve, reject) => {
        const reqData = data.reqData;
        $.ajax({
          type: "POST",
          url: server + data.url,
          data: reqData,
          dataType: "json",
          contentType: false, // Jangan set contentType karena FormData menangani hal itu
          processData: false, // Jangan proses data ke string, biarkan FormData bekerja secara otomatis
          success: function (response) {
            resolve(response);
          },
          error: function (error) {
            reject(
              error.responseJSON ? error.responseJSON.error : error.statusText
            );
          },
        });
      });
    },

    toglePreload() {
      this.preload = !this.preload;
    },
    togleAlert() {
      this.alert = !this.alert;
    },
  },
});

function tooglePreload() {
  useAppStore().preload = !useAppStore().preload
}
