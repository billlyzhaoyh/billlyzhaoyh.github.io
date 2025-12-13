---
title: "Human Layer Clone now available as a Claude plugin"
date: 2025-11-16
tags: [CI/CD, Claude Code, GitHub Actions, Human Layer, AI Automation]
excerpt: "Human Layer https://www.humanlayer.dev/ is a YC startup working on creating a better workflow for agentic tooling, and I have developed a Claude Code plugin with GitHub workflow scripts that let you build a similar workflow to Human Layer."
---

**TL;DR**: I made a working clone of https://github.com/humanlayer/humanlayer at  
https://github.com/billlyzhaoyh/humanlayer-clone, where you can install it as a Claude Code plugin and use all the commands described by Dex.

---

I randomly came across a video on my YouTube feed called *Advanced Context Engineering for Coding Agents*  
https://www.youtube.com/watch?v=IS_y40zY-hc, and it got me thinking about Claude Code–based automations.

I’ve been intrigued by the idea of **context compaction** practiced by the Human Layer team, and at the same time this video reminded me of an OpenAI AI Engineering Summit talk titled *The New Code*  
https://www.youtube.com/watch?v=8rABwKRsec4.

The core idea there is also striking: we write code in a functional language and then compile it into machine code. We throw away the machine code — or rather, we never see it or need it in the final codebase — and only keep the functional code.  

When it comes to AI agentic coding, this raises an interesting question: **why would we throw away the prompts after they are converted into functional code?** Undoubtedly, we are moving toward a future where engineers move away from reviewing raw code output and instead focus on reviewing the implementation plans proposed by LLMs.

---

In the Human Layer video, they showcased a simple three-step automation workflow that starts with creating a research document related to the ticket or task. We first refine the research document, and once we’re happy with it, we move on to the planning stage. The research phase covers a broad exploration of how the related functionalities work, allowing the planning agent to laser-focus on a specific task.

Once the plan is iterated on and approved, it is then implemented by a third agent. This entire flow is backed by Linear as the task management layer, with a particular task moving through the different stages.

---

Why do we want three steps of work like this versus the tried-and-tested Claude Code “plan then execute” workflow?

In my opinion, this approach concentrates much more effort upfront on planning and arriving at an implementation plan that is detailed enough for human developers to agree on. In contrast, the traditional Claude Code workflow often requires quite a few iterations to reach even a sub-par solution — iterations that could have been avoided by investing more effort in planning earlier.

---

To put what I built into practice, I tried out this clone on https://github.com/PAIR-code/lumi. I forked the repo and rewrote the backend to use **llmlite** rather than the Gemini backend, which allowed me to experience the advantages of using the Human Layer clone in a more mature repository.  

(This will come out soon — I just need to do a bit more QA.)

---

On a final note, I’d like to thank the Human Layer team for sharing these resources with the wider developer community. This project definitely started me on a journey to explore different tools we can build on top of Claude Code.
