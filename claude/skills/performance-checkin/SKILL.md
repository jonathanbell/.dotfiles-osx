---

## name: performance-checkin

description: Help write or evaluate a quarterly performance check-in — for yourself or a team member. Gathers evidence from Jira, GHE, Slack, and Confluence, then evaluates contributions critically with accurate role attribution. Use when filling out a check-in form, preparing for a performance conversation, or assessing a team member's quarter.

# Performance Check-in Skill

This skill applies to **self-evaluation** (filling out your own check-in) and **manager evaluation** (assessing a team member's contributions). The process and principles are the same in both cases.

---

## Step 1 — Understand context first

Before looking at any activity data, establish:

- **Team and project priorities** — what were the official goals and epics for the quarter? What did the team commit to?
- **The person's actual role in the team and projects** — not just their title, but what they actually did: were they making technical decisions, doing the implementation, unblocking others, coordinating across teams, reviewing work, or driving planning? This sets the lens for how contributions should be framed and what "good" looks like for them specifically
- **The quarter date range** — use this to filter all data sources consistently

---

## Step 2 — Gather evidence from multiple sources

No single source gives the full picture. Use all of these:

- **Jira** — pull all assigned tickets since the quarter start; count closed tickets (status: Closed/Done/Resolved) as the primary activity signal; check epics to understand official priorities
- **GHE / Bitbucket** — pull all PRs authored during the quarter; this is the most concrete evidence of personal technical contribution. Use GHE for IA/platform teams, Bitbucket for core Workday service teams — check which one the team uses
- **Slack** — use search and Slack AI to surface cross-team activity, incident involvement, planning discussions, and coordination work that never appears in Jira; this is often where the real story is
- **Slack** — count messages in selective work-focused channels and compare across teammates; read sampled messages to assess communication quality; use Slack AI for a synthesized summary of the person's activity
- **Confluence** — read referenced architecture and epic pages to understand scope, framing, and what was officially planned
- **Workday HCM** — check the Job Critical Skills list on the Career tab for reference, but treat it as a starting point only (see below)

### Quantitative benchmarking

Pull closed Jira tickets and GHE PR counts for the person **and their teammates** over the same date range. This gives calibration — not a ranking, but a sanity check on whether the numbers are in line with peers doing similar work.

**Queries to run (be explicit about scope for transparency):**

```
# Jira: closed tickets per person
# Project scope: list the Jira project(s) analyzed (e.g. IA, IPESRE)
JQL: assignee = "username" AND updated >= "YYYY-MM-DD" AND status in (Closed, Done, Resolved)

# Also break down by: issue type (Bug, Story, Task, Spike) and component
# to understand depth and breadth

# GHE: PRs authored per person
# Repo scope: list the repos analyzed (e.g. ai-assistant, fluxcd-aura, terraform-*)
GET /search/issues?q=author:ghe-username+type:pr+created:>=YYYY-MM-DD

# Bitbucket (if team uses bitbucket.workday.com):
GET /rest/api/1.0/dashboard/pull-requests?author=username&state=ALL&start=0&limit=100
# Also break down by repo to see where the work was concentrated
```

**Always state which Jira projects, GHE/Bitbucket repos, and Slack channels were analyzed** — this makes the numbers verifiable and flags if relevant sources were missed.

### Slack activity

Slack message counts in work channels are a proxy for communication, collaboration, and responsiveness — not a performance metric on their own. Skip casual or social channels; focus on work-relevant ones.

**Self vs. others — critical asymmetry:**

- Searching **your own** messages returns everything: DMs, private channels, all groups you're in — the full picture
- Searching **someone else's** messages only returns messages in channels you are also a member of — private channels and DMs you're not part of are invisible, so their counts are always understated
- Do not compare your own total directly against others' totals as if they're equivalent

**For self-analysis — search all channels to see full breadth:**

```
# Paginate through all results (100 per page) to get every channel
Slack search: from:me after:YYYY-MM-DD
# Group by channel, categorize: team/product, cross-team, community, leadership, ops/incidents
```

Total channel count and category spread reveals reach and influence beyond just volume.

**For peer comparison — use shared channels only:**

```
# Pick 3-5 key work channels the whole team participates in
Slack search: from:username in:#shared-channel after:YYYY-MM-DD
```

**What counts reveal:**

- Activity in the team's main dev channel — basic team engagement
- Activity in cross-team channels — collaboration beyond the immediate team
- Breadth of channels — narrow (focused) vs. wide (broad influence and reach)
- Activity in incident/ops channels — involvement in operational issues
- Activity in user/community channels — responsiveness and external engagement

**What counts don't reveal — read sampled messages to assess:**

- **Timeliness** — do they respond when tagged or when issues arise, or go quiet?
- **Clarity** — are messages clear, specific, and actionable, or vague?
- **Proactiveness** — do they surface issues before they become problems, share updates unprompted?
- **Quality of user support** — are they resolving user issues or deflecting?
- **Leadership signal** — are they driving decisions, unblocking others, or just participating?

**Grain of salt:** Message count varies by communication style — some people write many short messages, others fewer but more substantive ones. Use it as a starting point, not a conclusion.

**Summarize the type of work, not just the count:**

- Jira issue type mix (Bug vs. Story vs. Task) signals whether work was reactive (bugs) or planned (stories/features)
- Jira components show which areas of the system were touched — breadth across components vs. depth in one
- GHE repo spread shows whether work was concentrated in one service or spanned infrastructure, platform, and application layers

**Take these numbers with a grain of salt:**
Jira tickets and PRs vary enormously in size and complexity. One PR can be a one-line config fix or a 2,000-line feature. One ticket can be a 5-minute task or a month-long investigation. Raw counts are a starting point for conversation, not a performance score — always read the actual tickets and PRs to understand what the work involved.

**What to watch for:**

- High PR count with low Jira closed → infra/config work (many small PRs is normal for Terraform/FluxCD roles) or churn
- Low PR count with high Jira closed → coordination, planning, or tickets resolved without code changes
- Mostly bugs closed → reactive quarter; mostly stories → planned feature delivery
- Single component/repo → deep but narrow; many → broad but possibly shallow
- Low on both → investigate via Slack before drawing conclusions; coordination and planning work is often invisible in both

**Potential inaccuracies to call out:**

- Jira counts only capture the primary assignee — co-owned or unassigned tickets are missed
- GHE search only covers repos the token has access to; private or archived repos may be missed
- Tickets closed by automation or bulk-close are counted the same as real completions
- PRs in repos outside the team's main org won't appear unless searched explicitly
- Some people work across multiple Jira projects — if only one project is searched, their count is understated

For each contribution found, determine:

- What was the person's specific role — owner, key contributor, coordinator, reviewer, or supporter?
- Is there a concrete artifact — PR, ticket closed, decision made, blocker unblocked?
- Does it align to an official goal or epic?

---

## Step 3 — Evaluate critically

### Filter noise

- Volume of activity (messages, meetings, status updates, claims) is not contribution
- Look for concrete artifacts: PRs merged, bugs fixed, decisions made, blockers unblocked
- Trace back to who actually wrote the PR, fixed the bug, or made the call — not who talked about it most

### Role clarity matters

- Don't overclaim team outcomes as individual contributions
- Don't undersell genuine individual work either — proactive coordination, Slack routing setup, crisis untangling are real contributions even if invisible in Jira
- For shared work: be specific about what this person's part was

### Proactive planning and communication count

- Clarifying dependencies before a crisis, laying out a clear plan when things are unclear, communicating blockers early — these are real contributions
- Don't underestimate the value of untangling confusion, setting up conditions for others to succeed, or preventing a problem from happening

### Prevention over firefighting

- Quietly preventing an incident through good planning, early dependency identification, or proactive testing is more valuable than heroically resolving a crisis caused by poor planning or overselling
- Firefighting a crisis caused by external factors or other teams' mistakes is a genuine contribution worth calling out
- Firefighting a crisis the person caused or contributed to through poor planning is cleaning up their own mess — not a contribution

### Don't be misled by the loudest voice

- Someone claiming ownership or talking most in a channel doesn't mean they did the work
- "Claimed ready" and "actually delivered with testing and validation" are different things
- Be critical: if something was promised but not tested or validated, it doesn't count

### Honest scope

- If something is early or moving slowly, say it's on track or foundational — don't oversell
- Early-stage work that is genuinely progressing is fine to call out accurately
- Self-awareness about what is and isn't done yet builds credibility

---

## Step 4 — Select and frame contributions

Pick the **3 most significant contributions** aligned to official goals. For each:

- One sentence on what was done and what it enabled (not just what was built)
- 2-3 sub-bullets with concrete specifics

**Format:**

```
1. [Contribution title]
   - [Specific action and outcome]
   - [Specific action and outcome]
```

**Skills to highlight:** Name what actually mattered — don't force-fit to the Job Critical Skills list if something more relevant applies (e.g. AI fluency, cross-team coordination).

**Looking ahead:** Align to real open epics and priorities, not aspirational fluff.

---

## Step 5 — Development section

Show genuine reflection:

- What skill are you building, and why does it matter for the work ahead?
- What have you actually done to build it — concrete actions, not intentions
- What did you learn — where does the skill add real leverage vs. where doesn't it?
- What support do you genuinely need — be specific and honest; skip it if there's nothing real to ask for

---

## Handling the rigid form format

- Answer what's genuinely applicable; skip or neutralize what isn't
- Job Critical Skills list is often outdated — name what's actually relevant and why
- "What would you do differently" — if nothing genuine, skip it; don't manufacture self-criticism
- The form reader wants signal, not checkbox compliance
- Keep answers grounded in what's real

---

## Output style

Output format depends on the context:

**For a structured check-in form (e.g. Workday quarterly check-in):**

- 3 contributions max, each with 2-3 tight sub-bullets
- Sub-bullets concrete and specific, not generic
- No repetition across bullets
- Plain language — no corporate filler
- Skip questions that don't have a genuine answer

**For a general performance review, 1:1, or written manager assessment:**

- More flexible — narrative summary is fine alongside bullets
- Can include more context, evidence, and nuance
- Include quantitative data (Jira closed, PRs, Slack reach) to ground the assessment
- Call out patterns across contributions, not just individual items
- Development section can go deeper on learning and growth trajectory
- External signals (open source, community engagement, recognition) are worth including when relevant

---

## Reference example

See this session for a worked example of the full process applied end-to-end, including tool queries, role attribution corrections, and iterative refinement of the output.