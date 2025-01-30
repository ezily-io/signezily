import { z } from 'zod';

export const SUPPORTED_LANGUAGE_CODES = ['de', 'en', 'fr', 'es', 'it', 'pl', 'zh-tw'] as const;

export const ZSupportedLanguageCodeSchema = z.enum(SUPPORTED_LANGUAGE_CODES).catch('zh-tw');

export type SupportedLanguageCodes = (typeof SUPPORTED_LANGUAGE_CODES)[number];

export type I18nLocaleData = {
  /**
   * The supported language extracted from the locale.
   */
  lang: SupportedLanguageCodes;

  /**
   * The preferred locales.
   */
  locales: string[];
};

export const APP_I18N_OPTIONS = {
  supportedLangs: SUPPORTED_LANGUAGE_CODES,
  sourceLang: 'zh-tw',
  defaultLocale: 'zh-tw',
} as const;

type SupportedLanguage = {
  full: string;
  short: string;
};

export const SUPPORTED_LANGUAGES: Record<string, SupportedLanguage> = {
  de: {
    full: 'Deutsch',
    short: 'de',
  },
  en: {
    full: 'English',
    short: 'en',
  },
  fr: {
    full: 'Français',
    short: 'fr',
  },
  es: {
    full: 'Español',
    short: 'es',
  },
  ['zh-tw']: {
    full: '繁體中文',
    short: 'zh-tw',
  },
  it: {
    full: 'Italian',
    short: 'it',
  },
  pl: {
    short: 'pl',
    full: 'Polish',
  },
} satisfies Record<SupportedLanguageCodes, SupportedLanguage>;

export const isValidLanguageCode = (code: unknown): code is SupportedLanguageCodes =>
  SUPPORTED_LANGUAGE_CODES.includes(code as SupportedLanguageCodes);
