/* eslint-disable no-unused-vars, @typescript-eslint/no-unused-vars */
import type { Metadata } from 'next';
import { Caveat } from 'next/font/google';

import { setupI18nSSR } from '@documenso/lib/client-only/providers/i18n.server';
import { cn } from '@documenso/ui/lib/utils';

import { FasterSmarterBeautifulBento } from '~/components/(marketing)/faster-smarter-beautiful-bento';
import { Hero } from '~/components/(marketing)/hero';

export const revalidate = 600;
export const metadata: Metadata = {
  title: {
    absolute: 'Documenso - The Open Source DocuSign Alternative',
  },
};

const fontCaveat = Caveat({
  weight: ['500'],
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-caveat',
});

export default async function IndexPage() {
  await setupI18nSSR();

  return (
    <div className={cn('mt-12', fontCaveat.variable)}>
      <div className="mb-8 rounded border-l-4 border-amber-500 bg-amber-100 p-4 text-amber-800 shadow-sm">
        <p className="text-lg font-bold">Sunset Notice / 停止營運公告</p>
        <p>
          Signezily will be discontinued as a public service on <strong>March 15, 2026</strong>.
          Thank you for your support!
        </p>
        <p>
          本產品預計於 <strong>2026 年 3 月 15 日</strong> 正式停止服務，感謝您一直以來的支持！
        </p>
        <p className="mt-2 text-sm italic text-amber-700 underline underline-offset-4">
          Contact / 聯絡我們: <a href="mailto:hello@ezily.io">hello@ezily.io</a>
        </p>
      </div>
      <Hero />
      <FasterSmarterBeautifulBento className="my-48" />
    </div>
  );
}
