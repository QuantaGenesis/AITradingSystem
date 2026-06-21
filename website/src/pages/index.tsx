import React from 'react';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import styles from './index.module.css';

/* ── Feature card data ────────────────────────────────────────────────── */
const features = [
  {
    icon: '⚡',
    title: 'Event-Driven Core',
    desc: 'Market signals flow from triggers through the WebSocket gateway to trading groups in real time. No message queue required — FastAPI handles routing in-process.',
  },
  {
    icon: '🤖',
    title: 'Multi-Agent Discussion',
    desc: 'Each trading group assembles a team of AI agents — analyst, strategist, risk manager — that debate every signal before the group leader makes a decision.',
  },
  {
    icon: '🔌',
    title: 'Pluggable Triggers',
    desc: 'Copy the analyzer template, replace the data source, and your custom trigger (news, RSI, social sentiment) connects to the same gateway with zero backend changes.',
  },
  {
    icon: '📊',
    title: 'Exchange Execution',
    desc: 'Binance and OANDA adapters execute decisions. Simulated → Sandbox → Live rollout gives you full confidence before touching real capital.',
  },
  {
    icon: '🧠',
    title: 'Experience System',
    desc: 'Every closed trade is analyzed by an LLM extraction pipeline and stored as a searchable lesson. Future discussions retrieve relevant past experiences automatically.',
  },
  {
    icon: '🔒',
    title: 'Secure by Design',
    desc: 'Single-session token enforcement, role-scoped WebSocket permissions, startup secret guards, and security headers ship out of the box.',
  },
];

/* ── Architecture flow steps ─────────────────────────────────────────── */
const flowSteps = [
  { label: 'Trigger Service', color: '#10b981', desc: 'Monitors news, market data, or social signals' },
  { label: 'Event Gateway', color: '#3b82f6', desc: 'Validates, persists, and routes events via WebSocket' },
  { label: 'Trading Group', color: '#f59e0b', desc: 'AI agents discuss and produce a trade decision' },
  { label: 'Exec Engine', color: '#ef4444', desc: 'Places orders on the configured exchange' },
];

/* ── Component ────────────────────────────────────────────────────────── */
export default function Home(): JSX.Element {
  const { siteConfig } = useDocusaurusContext();

  return (
    <Layout
      title="AITradingSystem — AI Trading Platform"
      description="Event-driven AI trading platform. Market signals → multi-agent discussion → automated execution."
    >
      {/* ── Hero ──────────────────────────────────────────────────────── */}
      <header className={styles.hero}>
        <div className={styles.heroInner}>
          <div className={styles.badge}>Open-source · Self-hosted · Event-driven</div>
          <h1 className={styles.heroTitle}>
            AI-powered trading,<br />
            <span className={styles.heroAccent}>orchestrated by events.</span>
          </h1>
          <p className={styles.heroSubtitle}>
            AITradingSystem connects market triggers to multi-agent AI trading groups,
            producing reasoned decisions and executing orders — all on your own infrastructure.
          </p>
          <div className={styles.heroCta}>
            <Link className={styles.btnPrimary} to="/user-guide/intro">
              Get Started →
            </Link>
            <Link className={styles.btnSecondary} to="/dev-guide/intro">
              Developer Guide
            </Link>
          </div>

          {/* Terminal block */}
          <div className={styles.terminal}>
            <div className={styles.terminalBar}>
              <span className={styles.dot} style={{ background: '#ef4444' }} />
              <span className={styles.dot} style={{ background: '#f59e0b' }} />
              <span className={styles.dot} style={{ background: '#10b981' }} />
              <span style={{ color: '#6b7280', fontSize: '0.75rem', marginLeft: '0.5rem' }}>
                AITradingSystem — quick deploy
              </span>
            </div>
            <div className={styles.terminalBody}>
              <p><span className={styles.prompt}>$</span> mkdir AITradingSystem &amp;&amp; cd AITradingSystem</p>
              <p><span className={styles.prompt}>$</span> wget https://raw.githubusercontent.com/QuantaGenesis/AITradingSystem/main/install.sh</p>
              <p><span className={styles.prompt}>$</span> chmod +x install.sh</p>
              <p><span className={styles.prompt}>$</span> ./install.sh setup</p>
              <p><span className={styles.prompt}>$</span> ./install.sh start</p>
              <p style={{ color: '#10b981' }}>✓  backend    ready on :8000</p>
              <p style={{ color: '#10b981' }}>✓  frontend   ready on :3333 (or custom port)</p>
              <p style={{ color: '#10b981' }}>✓  database   healthy</p>
            </div>
          </div>
        </div>
      </header>

      <main>
        {/* ── Architecture Flow ──────────────────────────────────────── */}
        <section className={styles.section}>
          <div className={styles.container}>
            <h2 className={styles.sectionTitle}>How it works</h2>
            <p className={styles.sectionSubtitle}>
              Four stages, one coherent event flow. Each component is a standalone service
              that communicates over a secure WebSocket gateway.
            </p>
            <div className={styles.flowRow}>
              {flowSteps.map((step, i) => (
                <React.Fragment key={step.label}>
                  <div className={styles.flowStep}>
                    <div className={styles.flowNum} style={{ borderColor: step.color, color: step.color }}>
                      {i + 1}
                    </div>
                    <div className={styles.flowLabel} style={{ color: step.color }}>{step.label}</div>
                    <div className={styles.flowDesc}>{step.desc}</div>
                  </div>
                  {i < flowSteps.length - 1 && (
                    <div className={styles.flowArrow}>→</div>
                  )}
                </React.Fragment>
              ))}
            </div>
          </div>
        </section>

        {/* ── Feature Grid ──────────────────────────────────────────── */}
        <section className={styles.sectionAlt}>
          <div className={styles.container}>
            <h2 className={styles.sectionTitle}>Everything you need</h2>
            <div className={styles.featureGrid}>
              {features.map((f) => (
                <div key={f.title} className={styles.featureCard}>
                  <div className={styles.featureIcon}>{f.icon}</div>
                  <h3 className={styles.featureTitle}>{f.title}</h3>
                  <p className={styles.featureDesc}>{f.desc}</p>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* ── CTA Banner ────────────────────────────────────────────── */}
        <section className={styles.ctaBanner}>
          <div className={styles.container}>
            <h2 className={styles.ctaTitle}>Ready to deploy?</h2>
            <p className={styles.ctaDesc}>
              One Docker Compose command. Your own infrastructure. Full control.
            </p>
            <div className={styles.heroCta}>
              <Link className={styles.btnPrimary} to="/user-guide/installation/docker">
                Installation Guide →
              </Link>
              <Link className={styles.btnSecondary} to="/dev-guide/integration/trigger">
                Build a Trigger
              </Link>
            </div>
          </div>
        </section>
      </main>
    </Layout>
  );
}
