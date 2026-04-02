import { Outlet } from 'react-router';

import backgroundPattern from '@documenso/assets/images/background-pattern.png';

export default function Layout() {
  return (
    <main className="relative flex min-h-screen flex-col items-center justify-center overflow-hidden px-4 py-12 md:p-12 lg:p-24">
      <div className="relative z-10 mb-8 w-full max-w-lg rounded border-l-4 border-amber-500 bg-amber-100 p-4 text-amber-800 shadow-sm">
        <p className="text-lg font-bold">Sunset Notice / 停止營運公告</p>
        <p>
          Signezily will be discontinued on <strong>March 15, 2026</strong>. Thank you for your
          support!
        </p>
        <p>
          本產品上上簽預計於 <strong>2026 年 3 月 15 日</strong>{' '}
          正式停止服務，感謝您一直以來的支持！
        </p>
        <p className="mt-2 text-sm italic text-amber-700 underline underline-offset-4">
          Contact / 聯絡我們: <a href="mailto:hello@ezily.io">hello@ezily.io</a>
        </p>
      </div>
      <div>
        <div className="absolute -inset-[min(600px,max(400px,60vw))] -z-[1] flex items-center justify-center opacity-70">
          <img
            src={backgroundPattern}
            alt="background pattern"
            className="dark:brightness-95 dark:contrast-[70%] dark:invert dark:sepia"
            style={{
              mask: 'radial-gradient(rgba(255, 255, 255, 1) 0%, transparent 80%)',
              WebkitMask: 'radial-gradient(rgba(255, 255, 255, 1) 0%, transparent 80%)',
            }}
          />
        </div>

        <div className="relative w-full">
          <Outlet />
        </div>
      </div>
    </main>
  );
}
