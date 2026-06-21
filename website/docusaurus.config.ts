import { themes as prismThemes } from 'prism-react-renderer';
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'AITradingSystem',
  tagline: 'Event-driven AI trading platform — from market signals to decisions to execution.',
  favicon: 'img/favicon.ico',

  // Set the production URL of your site.
  // With a custom domain, baseUrl is always '/'.
  url: 'https://docs.quantagenesis.space',
  baseUrl: '/',

  // GitHub Pages config (for the CNAME approach)
  organizationName: 'QuantaGenesis',
  projectName: 'AITradingSystem',

  onBrokenLinks: 'throw',

  // Mermaid diagrams — many existing docs already use these
  markdown: {
    mermaid: true,
    hooks: {
      onBrokenMarkdownLinks: 'warn',
    },
  },
  themes: ['@docusaurus/theme-mermaid'],

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  plugins: [
    // ── User Guide ────────────────────────────────────────────────────────
    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'user',
        path: 'user-docs',
        routeBasePath: 'user-guide',
        sidebarPath: require.resolve('./sidebars-user.ts'),
        editUrl: 'https://github.com/QuantaGenesis/AITradingSystem/edit/main/website/',
      },
    ],
    // ── Developer Guide ───────────────────────────────────────────────────
    [
      '@docusaurus/plugin-content-docs',
      {
        id: 'dev',
        path: 'dev-docs',
        routeBasePath: 'dev-guide',
        sidebarPath: require.resolve('./sidebars-dev.ts'),
        editUrl: 'https://github.com/QuantaGenesis/AITradingSystem/edit/main/website/',
      },
    ],
  ],

  presets: [
    [
      'classic',
      {
        // Disable the default docs plugin — we use two custom instances above
        docs: false,
        blog: false,
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
        sitemap: {
          changefreq: 'weekly',
          priority: 0.5,
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Social card image
    image: 'img/social-card.png',

    colorMode: {
      defaultMode: 'dark',
      disableSwitch: false,
      respectPrefersColorScheme: true,
    },

    navbar: {
      title: 'AITradingSystem',
      logo: {
        alt: 'AITradingSystem Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          label: 'User Guide',
          to: '/user-guide/intro',
          position: 'left',
        },
        {
          label: 'Developer Guide',
          to: '/dev-guide/intro',
          position: 'left',
        },
        {
          href: 'https://github.com/QuantaGenesis/AITradingSystem',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },

    footer: {
      style: 'dark',
      links: [
        {
          title: 'User Guide',
          items: [
            { label: 'Introduction', to: '/user-guide/intro' },
            { label: 'Installation', to: '/user-guide/installation/docker' },
            { label: 'Quick Start', to: '/user-guide/quick-start' },
          ],
        },
        {
          title: 'Developer Guide',
          items: [
            { label: 'Architecture', to: '/dev-guide/architecture/overview' },
            { label: 'Trigger Integration', to: '/dev-guide/integration/trigger' },
            { label: 'Trading Group Integration', to: '/dev-guide/integration/trading-group' },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/QuantaGenesis/AITradingSystem',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} AITradingSystem. Built with Docusaurus.`,
    },

    prism: {
      theme: prismThemes.vsDark,
      darkTheme: prismThemes.vsDark,
      additionalLanguages: ['python', 'bash', 'json', 'yaml', 'docker'],
    },

    mermaid: {
      theme: { light: 'neutral', dark: 'dark' },
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
