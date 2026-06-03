# COPPA-focused moderation notes

This repository contains example Luau and Erlang moderation snippets that prioritize child safety and reduced data retention.

## Included safeguards

- Age-gate moderation before severe enforcement
- Disable voice collection for under-13 users
- Purge voice buffers instead of retaining them
- Use text-only review for child accounts
- Queue borderline child cases for human review
- Keep the adult moderation path unchanged

## Retention policy

- No persistent voice storage for child accounts
- Limited chat retention for child accounts
- Privacy settings should default to the most restrictive safe mode available

## Notes

This repository documents COPPA-focused safeguards, but full compliance depends on the surrounding product, consent flow, notices, retention rules, and legal review.
