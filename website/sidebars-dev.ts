import type { SidebarsConfig } from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  devSidebar: [
    {
      type: 'doc',
      id: 'intro',
      label: 'Overview',
    },
    {
      type: 'category',
      label: 'Architecture',
      collapsed: false,
      items: [
        'architecture/overview',
        'architecture/event-system',
        'architecture/websocket-protocol',
        'architecture/execution',
      ],
    },
    {
      type: 'category',
      label: 'Integration Guides',
      collapsed: false,
      items: [
        'integration/trigger',
        'integration/trading-group',
        'integration/exchange',
      ],
    },
    {
      type: 'category',
      label: 'Reference',
      items: [
        'reference/event-types',
        'reference/roles',
        'reference/security',
        'reference/backlog',
      ],
    },
  ],
};

export default sidebars;
