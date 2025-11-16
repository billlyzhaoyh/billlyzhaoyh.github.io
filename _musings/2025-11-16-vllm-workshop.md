---
title: "Attending the vLLM Workshop organised by Cast.ai at the MLops community Agent World event"
date: 2025-01-15
tags: [AI agent, Kubernetes, LLMOps]
excerpt: "Personal takeaways from Attending the vLLM Workshop organised by Cast.ai at the MLops community Agent World event"
---

As the AI or more specifically GenAI wildfire was spreading across the private organisations while I was still working for Education First late 2022, I have been following the developments from the frontier labs. The impressive progress of GPT model family drew me to OpenAI earlier on as I was prototyping different LLM based applications by connecting to frontier models with paid API access. At the time, people didn't believe wrapper companies would work but as the model intelligence keeps on scaling while the costs of these APIs scale down, it becomes obvious that if you have a product that solves customer pain points, you have a business and a moat.

During the early stages of ChatGPT 3.5 we were prototyping text2sql solutions (can probably write a standalone post on this) at some point and it was painful process of prompt engineering and hope for the best when LLMs are run in the wild. Soon enough people started to stress about Evals over vibes and we were definitely still relying on vibes. When GPT multi modal came out with the ability to look at images I tried two projects: one is to Understand TikTok videos to find underlying scripts and SOP of viral videos in different geographic locationn; and the other to look at shoe photos and identifying shoe fault. Random enough I know but it was fun to mess around the APIs.
  
When llama.ccp and Ollama was getting big I tried hosting 7B models on my own MacBook. It was a good demo to play around and feel the power and momentum of open source community (especially the satisfaction of seeing the metal GPU humming away at work) but obviously the model lacks the proper intelligence to do anything useful. With the exception where we had access to beefy Mac machine and a LLama 70B was hosted and I actually tried to use it for some coding questions but quickly pivoted to using ChatGPT or Claude admitting defeat. 

So where is the open source community at now? Kimi2thinking apparently surpass frontier closed model on some benchmarks so maybe the time is now? At the same time, my company would like to explore the possibility of hosting our own models. This workshop hosted by cast.ai at MLops community seems like the perfect opportunity to learn some hands on skills on hosting open sourced llms via vllm on k8s. 

So what did I learn from the workshop?
- vLLM has emerged as the framework of choice for hosting open sourced LLMs to deliver adequate performance in throughput and latency dependong on different use cases.
- It requires quite a lot of up front planning to work out the right amount of hardware and the models needed to satisfy a use case. For example for a chatbot use case in the enterprise setting, you might be expecting 1000s of concurrent users at a low latency to have a good product experience while for a document processing use cases, you will have a ton of input tokens to deal with but without latency concern you might want to maximise throughput.
- GPU maths are important to deliver an optimal performance. A nice trick instructor shared to see if the setup is memory bound or compute bound is to checks the ops per byte ratio meaning how many operations the GPU can perform per byte of memory. If the ratio is high, it means the GPU is compute bound and you might want to increase the batch size. If the ratio is low, it means the GPU is memory bound and you might want to decrease the batch size. For a given GPU card, you can calculate the rough optimal ops per byte ratio by dividing the compute bandwidth (in bytes per second) by the memory bandwidth (in bytes per second).
- We did quite a few whiteboarding activities trying to calculate the KV cache operations and number of computations for specific KV cache operations and this was important in the sense that if we want to optimise the GPU performance, we need to understand the underlying mechanisms of attention mechanism and how does quantisation affects the KV cache size for example. It was fun - almost like we were back in school!
- We also dived deep into the vLLM architecture and the request flow: the preread we were assigned from [this article](https://www.aleksagordic.com/blog/vllm) is a great read.

It was a shame we didn't get to try out the cast.ai product in practice where we were supposed to deploy a model on their EKS cluster but it was a great learning experience non-the-less! Once I start using the vLLM framework, I will share more details here.

Until next time :)
