import type { SidebarsConfig } from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  userSidebar: [
    {
      type: 'doc',
      id: 'intro',
      label: 'Introduction',
    },
    {
      type: 'doc',
      id: 'quick-start',
      label: 'Quick Start',
    },
    {
      type: 'category',
      label: 'Installation',
      collapsed: false,
      items: [
        'installation/docker',
        'installation/environment',
        'installation/install-script',
        'installation/manual',
      ],
    },
    {
      type: 'category',
      label: 'Configuration',
      items: [
        'configuration/basic-config',
        'configuration/trading-accounts',
      ],
    },
    {
      type: 'category',
      label: 'Using the Platform',
      items: [
        'user-guide/dashboard',
        'user-guide/automated-trading',
        'user-guide/triggers',
        'user-guide/trading-groups',
        'user-guide/trade-ops',
        'user-guide/trading-modes',
        'user-guide/event-test',
        'user-guide/experiences',
        'user-guide/troubleshooting',
      ],
    },
  ],
};

export default sidebars;
