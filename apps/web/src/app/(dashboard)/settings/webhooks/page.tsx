'use client';

import Link from 'next/link';

import { zodResolver } from '@hookform/resolvers/zod';
import { Trans, msg } from '@lingui/macro';
import { useLingui } from '@lingui/react';
import { Loader } from 'lucide-react';
import { DateTime } from 'luxon';
import { useSession } from 'next-auth/react';
import { useForm } from 'react-hook-form';
import { z } from 'zod';

import { toFriendlyWebhookEventName } from '@documenso/lib/universal/webhook/to-friendly-webhook-event-name';
import { trpc } from '@documenso/trpc/react';
import { cn } from '@documenso/ui/lib/utils';
import { Badge } from '@documenso/ui/primitives/badge';
import { Button } from '@documenso/ui/primitives/button';
import { Input } from '@documenso/ui/primitives/input';

import { SettingsHeader } from '~/components/(dashboard)/settings/layout/header';
import { CreateWebhookDialog } from '~/components/(dashboard)/settings/webhooks/create-webhook-dialog';
import { DeleteWebhookDialog } from '~/components/(dashboard)/settings/webhooks/delete-webhook-dialog';

export default function WebhookPage() {
  const { _, i18n } = useLingui();

  const { data: webhooks, isLoading } = trpc.webhook.getWebhooks.useQuery();

  const { data: session } = useSession();

  // Define ZWaitlistFormSchema as a Zod object
  const ZWaitlistFormSchema = z.object({
    email: z.string().email().optional(), // Add email field to the schema
  });

  // Update the type to include email
  type TWaitlistFormSchema = z.infer<typeof ZWaitlistFormSchema>;

  const waitlist = useForm<TWaitlistFormSchema>({
    resolver: zodResolver(ZWaitlistFormSchema),
    defaultValues: {
      email: '',
    },
  });

  const onJoinWaitlist = ({ email }: { email?: string }) => {
    // Update parameter type
    console.log(email);
  };

  if (!session) {
    return <div>Please log in to access this feature.</div>;
  }

  return (
    <>
      {session?.user.email == ' ' ? (
        <div>
          <SettingsHeader
            title={_(msg`Webhooks`)}
            subtitle={_(
              msg`On this page, you can create new Webhooks and manage the existing ones.`,
            )}
          >
            <CreateWebhookDialog />
          </SettingsHeader>

          {isLoading && (
            <div className="absolute inset-0 flex items-center justify-center bg-white/50">
              <Loader className="h-8 w-8 animate-spin text-gray-500" />
            </div>
          )}

          {webhooks && webhooks.length === 0 && (
            // TODO: Perhaps add some illustrations here to make the page more engaging
            <div className="mb-4">
              <p className="text-muted-foreground mt-2 text-sm italic">
                <Trans>
                  You have no webhooks yet. Your webhooks will be shown here once you create them.
                </Trans>
              </p>
            </div>
          )}

          {webhooks && webhooks.length > 0 && (
            <div className="mt-4 flex max-w-xl flex-col gap-y-4">
              {webhooks?.map((webhook) => (
                <div
                  key={webhook.id}
                  className={cn(
                    'border-border rounded-lg border p-4',
                    !webhook.enabled && 'bg-muted/40',
                  )}
                >
                  <div className="flex flex-col gap-x-4 sm:flex-row sm:items-center sm:justify-between">
                    <div>
                      <div className="truncate font-mono text-xs">{webhook.id}</div>

                      <div className="mt-1.5 flex items-center gap-4">
                        <h5
                          className="max-w-[30rem] truncate text-sm sm:max-w-[18rem]"
                          title={webhook.webhookUrl}
                        >
                          {webhook.webhookUrl}
                        </h5>

                        <Badge variant={webhook.enabled ? 'neutral' : 'warning'} size="small">
                          {webhook.enabled ? <Trans>Enabled</Trans> : <Trans>Disabled</Trans>}
                        </Badge>
                      </div>

                      <p className="text-muted-foreground mt-2 text-xs">
                        <Trans>
                          Listening to{' '}
                          {webhook.eventTriggers
                            .map((trigger) => toFriendlyWebhookEventName(trigger))
                            .join(', ')}
                        </Trans>
                      </p>

                      <p className="text-muted-foreground mt-2 text-xs">
                        <Trans>
                          Created on {i18n.date(webhook.createdAt, DateTime.DATETIME_FULL)}
                        </Trans>
                      </p>
                    </div>

                    <div className="mt-4 flex flex-shrink-0 gap-4 sm:mt-0">
                      <Button asChild variant="outline">
                        <Link href={`/settings/webhooks/${webhook.id}`}>
                          <Trans>Edit</Trans>
                        </Link>
                      </Button>
                      <DeleteWebhookDialog webhook={webhook}>
                        <Button variant="destructive">
                          <Trans>Delete</Trans>
                        </Button>
                      </DeleteWebhookDialog>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      ) : (
        <form onSubmit={waitlist.handleSubmit(onJoinWaitlist)}>
          <Trans>
            Webhook related features have been move to a seperate platform, please leave your email
            and we will contact you shortly.
          </Trans>
          <div className="mt-4 flex items-center gap-2">
            <Input
              type="text"
              placeholder="your email"
              {...waitlist.register('email')}
              className="flex-1"
            />
            <Button type="submit">
              <Trans>submit</Trans>
            </Button>
          </div>
        </form>
      )}
    </>
  );
}
