import { createElement } from 'react';

import { msg } from '@lingui/macro';
import { z } from 'zod';

import { mailer } from '@documenso/email/mailer';
import LineSupportEmailTemplate from '@documenso/email/templates/line-support';
import { prisma } from '@documenso/prisma';

import { getI18nInstance } from '../../../client-only/providers/i18n.server';
import { WEBAPP_BASE_URL } from '../../../constants/app';
import { SUPPORT_EMAIL } from '../../../constants/email';
import { renderEmailWithI18N } from '../../../utils/render-email-with-i18n';
import type { JobDefinition } from '../../client/_internal/job';

const SEND_LINE_SUPPORT_EMAIL_JOB_DEFINITION_ID = 'send.line-support.email';

const SEND_LINE_SUPPORT_EMAIL_JOB_DEFINITION_SCHEMA = z.object({
  memberUserId: z.number(),
});

export const SEND_LINE_SUPPORT_EMAIL_JOB_DEFINITION = {
  id: SEND_LINE_SUPPORT_EMAIL_JOB_DEFINITION_ID,
  name: 'Send Line Support Email',
  version: '1.0.0',
  trigger: {
    name: SEND_LINE_SUPPORT_EMAIL_JOB_DEFINITION_ID,
    schema: SEND_LINE_SUPPORT_EMAIL_JOB_DEFINITION_SCHEMA,
  },
  handler: async ({ payload, io }) => {
    const member = await prisma.user.findFirstOrThrow({
      where: {
        id: payload.memberUserId,
      },
    });

    await io.runTask(`send-line-support-email_${member.id}`, async () => {
      const emailContent = createElement(LineSupportEmailTemplate, {
        assetBaseUrl: WEBAPP_BASE_URL,
        memberName: member.name || '',
        memberEmail: member.email,
      });

      const [html, text] = await Promise.all([
        renderEmailWithI18N(emailContent, {}),
        renderEmailWithI18N(emailContent, {
          plainText: true,
        }),
      ]);

      const i18n = await getI18nInstance();

      await mailer.sendMail({
        to: SUPPORT_EMAIL,
        from: {
          name: member.name || '',
          address: member.email,
        },
        subject: i18n._(
          msg`${member.name || member.email} is requesting support with the line integration`,
        ),
        html,
        text,
      });
    });
  },
} as const satisfies JobDefinition<
  typeof SEND_LINE_SUPPORT_EMAIL_JOB_DEFINITION_ID,
  z.infer<typeof SEND_LINE_SUPPORT_EMAIL_JOB_DEFINITION_SCHEMA>
>;
