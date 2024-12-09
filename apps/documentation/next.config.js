import nextra from 'nextra';

/** @type {import('next').NextConfig} */
const nextConfig = {
  output: process.env.DOCKER_OUTPUT ? 'standalone' : undefined,
  transpilePackages: [
    '@documenso/assets',
    '@documenso/lib',
    '@documenso/tailwind-config',
    '@documenso/trpc',
    '@documenso/ui',
  ],
};

const withNextra = nextra({
  theme: 'nextra-theme-docs',
  themeConfig: './theme.config.tsx',
  codeHighlight: true,
});

export default withNextra(nextConfig);
