// Composables
import { useAppStore } from "@/store/app";
import { createRouter, createWebHistory } from "vue-router";

const routes = [
  {
    path: "/",
    redirect: "/login",
    component: () => import("@/layouts/outerLayout.vue"),
    children: [
      {
        path: "/login",
        name: "Login",
        component: () =>
          import(/* webpackChunkName: "home" */ "@/views/pages/loginPages.vue"),
      },
    ],
  },
  {
    path: "/home",
    name: "Home",
    redirect: () => {
      const app = JSON.parse(localStorage.getItem("app"))
      return app.session.auth.home
    },
    component: () => import("@/layouts/innerLayout.vue"),
    children: [
      {
        path: "/home/userssetting",
        name: "Users Setting",
        component: () => import("@/views/settings/usersSetting.vue"),
      },
      {
        path: "/home/dashboard",
        name: "Dashboard",
        component: () => import("@/views/pages/dashBoard.vue"),
      },
      {
        path: "/home/inspectionsetup",
        name: "Inspection Setup",
        component: () => import("@/views/settings/inspectionSetup.vue"),
      },
      {
        path: "/home/menusetting",
        name: "Menu Setting",
        component: () => import("@/views/settings/menuSetting.vue"),
      },
      {
        path: "/home/newinspection",
        name: "New Inpection",
        component: () => import("@/views/features/newInspection.vue"),
      },
      {
        path: "/home/inspectioncheck",
        name: "Inspection Check",
        component: () => import("@/views/features/inspectionCheck.vue"),
      },
      {
        path: "/home/finishinspection",
        name: "Finish Inspection",
        component: () => import("@/views/features/finishInspection.vue"),
      },
      {
        path: "/home/nginspection",
        name: "NG Inspection",
        component: () => import("@/views/features/ngInspection.vue"),
      },
      {
        path: "/home/registrasipir",
        name: "Part Registration",
        component: () => import("@/views/features/registrationNewPir.vue"),
      },
    ],
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;

router.beforeEach(async (e) => {
  const alert = useAppStore().alert;
  if (e.matched.length < 1) {
    alert.fire({
      title: "Not Found",
      icon: "error",
      text: "Page not found",
    });
    router.push("/home");
  }
  if (e.fullPath != "/login") {
    const token = useAppStore().session.auth.token;
    if (token === null) {
      router.push("/login");
    } else {
      const path = e.fullPath;
      const reqData = { token: token, path: path };
      try {
        await useAppStore().ajaxPost({ url: "auth/getaccess", reqData });
      } catch (error) {
        alert.fire({
          title: "Forbidden",
          icon: "warning",
          text: error,
        });
        router.push("/home");
      }
    }
  } else {
    const token = useAppStore().session.auth.token;
    if (token != null) {
      router.push("/home");
    }
  }
});
