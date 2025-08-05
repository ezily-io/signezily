'use client';

import React, { useEffect, useState } from 'react';

import { usePathname } from 'next/navigation';

import { NEXT_PUBLIC_WEBAPP_URL } from '@documenso/lib/constants/app';
import { cn } from '@documenso/ui/lib/utils';

import { Footer } from '~/components/(marketing)/footer';
import { Header } from '~/components/(marketing)/header';

export type MarketingLayoutProps = {
  children: React.ReactNode;
};

export default function MarketingLayout({ children }: MarketingLayoutProps) {
  const [scrollY, setScrollY] = useState(0);
  const pathname = usePathname();

  // const { getFlag } = useFeatureFlags();

  const showProfilesAnnouncementBar = false;

  useEffect(() => {
    const onScroll = () => {
      setScrollY(window.scrollY);
    };

    window.addEventListener('scroll', onScroll);

    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  return (
    <div
      className={cn('relative flex min-h-[100vh] max-w-[100vw] flex-col pt-20 md:pt-28', {
        'overflow-y-auto overflow-x-hidden':
          pathname && !['/singleplayer', '/pricing'].includes(pathname),
      })}
    >
      <div
        className={cn('fixed left-0 top-0 z-50 w-full bg-transparent', {
          'bg-background/50 backdrop-blur-md': scrollY > 5,
        })}
      >
        {showProfilesAnnouncementBar && (
          <div className="relative inline-flex w-full items-center justify-center overflow-hidden bg-[#e7f3df] px-4 py-2.5">
            <div className="text-center text-sm font-medium text-black">
              Claim your documenso public profile username now!{' '}
              <span className="hidden font-semibold md:inline">documenso.com/u/yourname</span>
              <div className="mt-1.5 block md:ml-4 md:mt-0 md:inline-block">
                <a
                  href={`${NEXT_PUBLIC_WEBAPP_URL()}/signup?utm_source=marketing-announcement-bar`}
                  className="bg-background text-foreground rounded-md px-2.5 py-1 text-xs font-medium duration-300"
                >
                  Claim Now
                </a>
              </div>
            </div>
          </div>
        )}

        <Header className="mx-auto h-16 max-w-screen-xl px-4 md:h-20 lg:px-8" />
      </div>

      <div className="relative max-w-screen-xl flex-1 px-4 sm:mx-auto lg:px-8">{children}</div>

      <Footer className="bg-background border-muted mt-24 border-t" />
    </div>
  );
}
