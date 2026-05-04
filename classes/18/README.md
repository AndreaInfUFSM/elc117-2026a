<!--
author:   Andrea Charão

email:    andrea@inf.ufsm.br

version:  0.0.1

language: PT-BR

narrator: Brazilian Portuguese Female

comment:  Material de apoio para a disciplina
          ELC117 - Paradigmas de Programação
          da Universidade Federal de Santa Maria

translation: English  translations/English.md

link:     https://cdn.jsdelivr.net/gh/AndreaInfUFSM/elc117-2026a@main/assets/css/custom.css

script:   https://cdn.jsdelivr.net/gh/AndreaInfUFSM/elc117-2026a@main/assets/js/goatcounter-config.js
script:   https://gc.zgo.at/count.js

@onload
window.CodeRunner = {
    ws: undefined,
    handler: {},
    connected: false,
    error: "",
    url: "",
    firstConnection: true,

    init(url, step = 0) {
        this.url = url
        if (step  >= 10) {
           console.warn("could not establish connection")
           this.error = "could not establish connection to => " + url
           return
        }

        this.ws = new WebSocket(url);

        const self = this
        
        const connectionTimeout = setTimeout(() => {
          self.ws.close();
          console.log("WebSocket connection timed out");
        }, 5000);
        
        
        this.ws.onopen = function () {
            clearTimeout(connectionTimeout);
            self.log("connections established");

            self.connected = true
            
            setInterval(function() {
                self.ws.send("ping")
            }, 15000);
        }
        this.ws.onmessage = function (e) {
            // e.data contains received string.

            let data
            try {
                data = JSON.parse(e.data)
            } catch (e) {
                self.warn("received message could not be handled =>", e.data)
            }
            if (data) {
                self.handler[data.uid](data)
            }
        }
        this.ws.onclose = function () {
            clearTimeout(connectionTimeout);
            self.connected = false
            self.warn("connection closed ... reconnecting")

            setTimeout(function(){
                console.warn("....", step+1)
                self.init(url, step+1)
            }, 1000)
        }
        this.ws.onerror = function (e) {
            clearTimeout(connectionTimeout);
            self.warn("an error has occurred")
        }
    },
    log(...args) {
        window.console.log("CodeRunner:", ...args)
    },
    warn(...args) {
        window.console.warn("CodeRunner:", ...args)
    },
    handle(uid, callback) {
        this.handler[uid] = callback
    },
    send(uid, message, sender=null, restart=false) {
        const self = this
        if (this.connected) {
          message.uid = uid
          this.ws.send(JSON.stringify(message))
        } else if (this.error) {

          if(restart) {
            sender.lia("LIA: terminal")
            this.error = ""
            this.init(this.url)
            setTimeout(function() {
              self.send(uid, message, sender, false)
            }, 2000)

          } else {
            //sender.lia("LIA: wait")
            setTimeout(() => {
              sender.lia(" " + this.error)
              sender.lia(" Maybe reloading fixes the problem ...")
              sender.lia("LIA: stop")
            }, 800)
          }
        } else {
          setTimeout(function() {
            self.send(uid, message, sender, false)
          }, 2000)
          
          if (sender) {
            
            sender.lia("LIA: terminal")
            if (this.firstConnection) {
              this.firstConnection = false
              setTimeout(() => { 
                sender.log("stream", "", [" Waking up execution server ...\n", "This may take up to 30 seconds ...\n", "Please be patient ...\n"])
              }, 100)
            } else {
              sender.log("stream", "", ".")
            }
            sender.lia("LIA: terminal")
          }
        }
    }
}

//window.CodeRunner.init("wss://coderunner.informatik.tu-freiberg.de/")
//window.CodeRunner.init("ws://localhost:4000/")
window.CodeRunner.init("wss://ancient-hollows-41316.herokuapp.com/")
@end

@LIA.c:                 @LIA.eval(`["main.c"]`, `gcc -Wall main.c -o a.out`, `./a.out`)
@LIA.prolog:            @LIA.eval(`["main.pl"]`, `none`, `swipl -s main.pl -g @0 -t halt`)
@LIA.prolog_withShell:  @LIA.eval(`["main.pl"]`, `none`, `swipl -s main.pl`)
@LIA.haskell:           @LIA.eval(`["main.hs"]`, `ghc main.hs -o main`, `./main`)
@LIA.haskell_withShell: @LIA.eval(`["main.hs"]`, `none`, `ghci main.hs`)

@LIA.eval:  @LIA.eval_(false,`@0`,@1,@2,@3)

@LIA.evalWithDebug: @LIA.eval_(true,`@0`,@1,@2,@3)

@LIA.eval_
<script>
function random(len=16) {
    let chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let str = '';
    for (let i = 0; i < len; i++) {
        str += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return str;
}



const uid = random()
var order = @1
var files = []

var pattern = "@4".trim()

if (pattern.startsWith("\`")){
  pattern = pattern.slice(1,-1)
} else if (pattern.length === 2 && pattern[0] === "@") {
  pattern = null
}

if (order[0])
  files.push([order[0], `@'input(0)`])
if (order[1])
  files.push([order[1], `@'input(1)`])
if (order[2])
  files.push([order[2], `@'input(2)`])
if (order[3])
  files.push([order[3], `@'input(3)`])
if (order[4])
  files.push([order[4], `@'input(4)`])
if (order[5])
  files.push([order[5], `@'input(5)`])
if (order[6])
  files.push([order[6], `@'input(6)`])
if (order[7])
  files.push([order[7], `@'input(7)`])
if (order[8])
  files.push([order[8], `@'input(8)`])
if (order[9])
  files.push([order[9], `@'input(9)`])


send.handle("input", (e) => {
    CodeRunner.send(uid, {stdin: e}, send)
})
send.handle("stop",  (e) => {
    CodeRunner.send(uid, {stop: true}, send)
});


CodeRunner.handle(uid, function (msg) {
    switch (msg.service) {
        case 'data': {
            if (msg.ok) {
                CodeRunner.send(uid, {compile: @2}, send)
            }
            else {
                send.lia("LIA: stop")
            }
            break;
        }
        case 'compile': {
            if (msg.ok) {
                if (msg.message) {
                    if (msg.problems.length)
                        console.warn(msg.message);
                    else
                        console.log(msg.message);
                }

                send.lia("LIA: terminal")
                CodeRunner.send(uid, {exec: @3, filter: pattern})

                if(!@0) {
                  console.clear()
                }
            } else {
                send.lia(msg.message, msg.problems, false)
                send.lia("LIA: stop")
            }
            break;
        }
        case 'stdout': {
            if (msg.ok)
                console.stream(msg.data)
            else
                console.error(msg.data);
            break;
        }

        case 'stop': {
            if (msg.error) {
                console.error(msg.error);
            }

            if (msg.images) {
                for(let i = 0; i < msg.images.length; i++) {
                    console.html("<hr/>", msg.images[i].file)
                    console.html("<img title='" + msg.images[i].file + "' src='" + msg.images[i].data + "' onclick='window.LIA.img.click(\"" + msg.images[i].data + "\")'>")
                }
            }

            if (msg.videos) {
                for(let i = 0; i < msg.videos.length; i++) {
                    console.html("<hr/>", msg.videos[i].file)
                    console.html("<video controls style='width:100%' title='" + msg.videos[i].file + "' src='" + msg.videos[i].data + "'></video>")
                }
            }

            if (msg.files) {
                let str = "<hr/>"
                for(let i = 0; i < msg.files.length; i++) {
                    str += `<a href='data:application/octet-stream${msg.files[i].data}' download="${msg.files[i].file}">${msg.files[i].file}</a> `
                }

                console.html(str)
            }

            window.console.warn(msg)

            send.lia("LIA: stop")
            break;
        }

        default:
            console.log(msg)
            break;
    }
})


CodeRunner.send(
    uid, { "data": files }, send, true
);

"LIA: wait"
</script>
@end

-->

<!--
nvm use v14.21.1
liascript-devserver --input README.md --port 3001 --live
-->


[![LiaScript](https://raw.githubusercontent.com/LiaScript/LiaScript/master/badges/course.svg)](https://liascript.github.io/course/?https://raw.githubusercontent.com/AndreaInfUFSM/elc117-2026a/main/classes/18/README.md)


# Resultados: prova de leitura de código



<svg viewBox="0 0 520 190" width="100%" role="img" aria-label="Bimester grade composition: exam 50 percent, assessment 1 20 percent, assessment 2 30 percent" xmlns="http://www.w3.org/2000/svg">
  <style>
    .card {
      fill: #ffffff;
      stroke: #e5e7eb;
      stroke-width: 1;
    }

    .title {
      font: 700 12px system-ui, sans-serif;
      fill: #111827;
    }

    .subtitle {
      font: 400 12px system-ui, sans-serif;
      fill: #6b7280;
    }

    .label {
      font: 500 12px system-ui, sans-serif;
      fill: #374151;
    }

    .small {
      font: 400 11px system-ui, sans-serif;
      fill: #6b7280;
    }
  </style>

  <!-- Card background -->
  <rect x="0.5" y="0.5" width="519" height="189" rx="18" class="card" />

  <!-- Header -->
  <text x="24" y="34" class="title">Modalidades de avaliação no primeiro bimestre</text>
  <text x="24" y="54" class="subtitle">Prova corresponde a 50%</text>

  <!-- Rounded stacked bar mask -->
  <defs>
    <clipPath id="bimester-bar-clip">
      <rect x="24" y="78" width="472" height="22" rx="11" />
    </clipPath>
  </defs>

  <!-- Bar background -->
  <rect x="24" y="78" width="472" height="22" rx="11" fill="#e5e7eb" />

  <!-- Segments clipped by the rounded container -->
  <g clip-path="url(#bimester-bar-clip)">
    <rect x="24" y="78" width="236" height="22" fill="#147375" />
    <rect x="260" y="78" width="94.4" height="22" fill="#9ca3af" />
    <rect x="354.4" y="78" width="141.6" height="22" fill="#d1d5db" />
  </g>

  <!-- Percent labels inside bar -->
  <text x="142" y="94" text-anchor="middle" font="700 12px system-ui, sans-serif" fill="#ffffff">50%</text>
  <text x="307.2" y="94" text-anchor="middle" font="700 12px system-ui, sans-serif" fill="#ffffff">20%</text>
  <text x="425.2" y="94" text-anchor="middle" font="700 12px system-ui, sans-serif" fill="#ffffff">30%</text>

  <!-- Legend: vertically stacked -->
  <g transform="translate(24, 124)">
    <rect x="0" y="0" width="10" height="10" rx="2" fill="#147375" />
    <text x="16" y="9" class="small">Prova</text>
    <text x="246" y="9" class="small">50%</text>

    <rect x="0" y="22" width="10" height="10" rx="2" fill="#9ca3af" />
    <text x="16" y="31" class="small">Apresentação de exercícios</text>
    <text x="246" y="31" class="small">20%</text>

    <rect x="0" y="44" width="10" height="10" rx="2" fill="#d1d5db" />
    <text x="16" y="53" class="small">Produção individual personalizada</text>
    <text x="246" y="53" class="small">30%</text>
  </g>
</svg>


<svg viewBox="0 0 520 190" width="100%" role="img" aria-label="Exam composition: four Haskell questions worth 1 point each and one Prolog question divided into two parts worth 0.5 each" xmlns="http://www.w3.org/2000/svg">
  <style>
    .card {
      fill: #ffffff;
      stroke: #e5e7eb;
      stroke-width: 1;
    }

    .title {
      font: 700 12px system-ui, sans-serif;
      fill: #111827;
    }

    .subtitle {
      font: 400 12px system-ui, sans-serif;
      fill: #6b7280;
    }

    .label {
      font: 500 12px system-ui, sans-serif;
      fill: #374151;
    }

    .small {
      font: 400 11px system-ui, sans-serif;
      fill: #6b7280;
    }
  </style>

  <!-- Card background -->
  <rect x="0.5" y="0.5" width="519" height="189" rx="18" class="card" />

  <!-- Header -->
  <text x="24" y="34" class="title">Composição da prova</text>
  <text x="24" y="54" class="subtitle">4 questões sobre Haskell e 1 questão sobre Prolog, dividida em 5a e 5b</text>

  <!-- Rounded stacked bar mask -->
  <defs>
    <clipPath id="exam-composition-bar-clip">
      <rect x="24" y="78" width="472" height="22" rx="11" />
    </clipPath>
  </defs>

  <!-- Bar background -->
  <rect x="24" y="78" width="472" height="22" rx="11" fill="#e5e7eb" />

  <!-- 
    Total exam value: 5.0
    Questions 1-4: 1.0 each = 4.0 = 80%
    Question 5a: 0.5 = 10%
    Question 5b: 0.5 = 10%

    Bar width: 472
    Each 1.0 question: 94.4
    Each 0.5 part: 47.2
  -->
  <g clip-path="url(#exam-composition-bar-clip)">
    <!-- Haskell: questions 1 to 4 -->
    <rect x="24" y="78" width="94.4" height="22" fill="#6b5ca5" />
    <rect x="118.4" y="78" width="94.4" height="22" fill="#7c6bb8" />
    <rect x="212.8" y="78" width="94.4" height="22" fill="#6b5ca5" />
    <rect x="307.2" y="78" width="94.4" height="22" fill="#7c6bb8" />

    <!-- Prolog: question 5a and 5b -->
    <rect x="401.6" y="78" width="47.2" height="22" fill="#f97316" />
    <rect x="448.8" y="78" width="47.2" height="22" fill="#fb923c" />
  </g>

  <!-- Labels inside bar -->
  <text x="71.2" y="94" text-anchor="middle" font="700 10px system-ui, sans-serif" fill="#ffffff">1</text>
  <text x="165.6" y="94" text-anchor="middle" font="700 10px system-ui, sans-serif" fill="#ffffff">2</text>
  <text x="260" y="94" text-anchor="middle" font="700 10px system-ui, sans-serif" fill="#ffffff">3</text>
  <text x="354.4" y="94" text-anchor="middle" font="700 10px system-ui, sans-serif" fill="#ffffff">4</text>
  <text x="425.2" y="94" text-anchor="middle" font="700 9px system-ui, sans-serif" fill="#ffffff">5a</text>
  <text x="472.4" y="94" text-anchor="middle" font="700 9px system-ui, sans-serif" fill="#ffffff">5b</text>

  <!-- Legend: vertically stacked -->
  <g transform="translate(24, 124)">
    <rect x="0" y="0" width="10" height="10" rx="2" fill="#6b5ca5" />
    <text x="16" y="9" class="small">Questões 1 a 4: leitura de código em Haskell</text>
    <text x="360" y="9" class="small">4 × 1,0 = 4,0</text>

    <rect x="0" y="22" width="10" height="10" rx="2" fill="#f97316" />
    <text x="16" y="31" class="small">Questão 5: leitura de código em Prolog</text>
    <text x="360" y="31" class="small">5a + 5b = 1,0</text>


  </g>
</svg>


<svg viewBox="0 0 520 150" width="100%" role="img" aria-label="Exam participation: 28 participants out of 34 enrolled students, representing 82.4 percent" xmlns="http://www.w3.org/2000/svg">
  <style>
    .card {
      fill: #ffffff;
      stroke: #e5e7eb;
      stroke-width: 1;
    }

    .title {
      font: 700 12px system-ui, sans-serif;
      fill: #111827;
    }

    .subtitle {
      font: 400 12px system-ui, sans-serif;
      fill: #6b7280;
    }

    .big {
      font: 800 28px system-ui, sans-serif;
      fill: #111827;
    }

    .label {
      font: 500 12px system-ui, sans-serif;
      fill: #374151;
    }

    .small {
      font: 400 11px system-ui, sans-serif;
      fill: #6b7280;
    }
  </style>

  <!-- Card background -->
  <rect x="0.5" y="0.5" width="519" height="149" rx="18" class="card" />

  <!-- Header -->
  <text x="24" y="34" class="title">Participação na prova</text>
  <text x="24" y="54" class="subtitle">28 estudantes participaram, de um total de 34 matriculados</text>

  <!-- Main number -->
  <text x="24" y="91" class="big">28/34</text>
  <text x="118" y="88" class="label">estudantes</text>
  <text x="118" y="105" class="small">82,4% de participação</text>

  <!-- Participation bar -->
  <defs>
    <clipPath id="participation-bar-clip">
      <rect x="24" y="122" width="472" height="14" rx="7" />
    </clipPath>
  </defs>

  <rect x="24" y="122" width="472" height="14" rx="7" fill="#e5e7eb" />

  <!-- 82.4% of 472 = 389.0 -->
  <g clip-path="url(#participation-bar-clip)">
    <rect x="24" y="122" width="389" height="14" fill="#147375" />
  </g>

  <!-- Bar labels -->
  <text x="24" y="116" class="small">0%</text>
  <text x="413" y="116" text-anchor="middle" class="small">82,4%</text>
  <text x="496" y="116" text-anchor="end" class="small">100%</text>
</svg>


<svg viewBox="0 0 520 190" width="100%" role="img" aria-label="Grade distribution: 17 students scored 7 or above, 5 students scored between 5 and 7, and 6 students scored below 5" xmlns="http://www.w3.org/2000/svg">
  <style>
    .card {
      fill: #ffffff;
      stroke: #e5e7eb;
      stroke-width: 1;
    }

    .title {
      font: 700 12px system-ui, sans-serif;
      fill: #111827;
    }

    .subtitle {
      font: 400 12px system-ui, sans-serif;
      fill: #6b7280;
    }

    .label {
      font: 500 12px system-ui, sans-serif;
      fill: #374151;
    }

    .small {
      font: 400 11px system-ui, sans-serif;
      fill: #6b7280;
    }

    .inside {
      font: 700 11px system-ui, sans-serif;
      fill: #ffffff;
    }
  </style>

  <!-- Card background -->
  <rect x="0.5" y="0.5" width="519" height="189" rx="18" class="card" />

  <!-- Header -->
  <text x="24" y="34" class="title">Distribuição das notas na prova</text>
  <text x="24" y="54" class="subtitle">Resultados considerando os 28 estudantes que participaram</text>

  <!-- Rounded stacked bar mask -->
  <defs>
    <clipPath id="grade-distribution-bar-clip">
      <rect x="24" y="78" width="472" height="22" rx="11" />
    </clipPath>
  </defs>

  <!-- Bar background -->
  <rect x="24" y="78" width="472" height="22" rx="11" fill="#e5e7eb" />

  <!--
    Total participants: 28
    >= 7: 17 students = 60.7% -> width 286.6
    5 to < 7: 5 students = 17.9% -> width 84.3
    < 5: 6 students = 21.4% -> width 101.1
  -->
  <g clip-path="url(#grade-distribution-bar-clip)">
    <rect x="24" y="78" width="286.6" height="22" fill="#10b981" />
    <rect x="310.6" y="78" width="84.3" height="22" fill="#f59e0b" />
    <rect x="394.9" y="78" width="101.1" height="22" fill="#ef4444" />
  </g>

  <!-- Labels inside bar -->
  <text x="167.3" y="94" text-anchor="middle" class="inside">17</text>
  <text x="352.75" y="94" text-anchor="middle" class="inside">5</text>
  <text x="445.45" y="94" text-anchor="middle" class="inside">6</text>

  <!-- Legend: vertically stacked -->
  <g transform="translate(24, 124)">
    <rect x="0" y="0" width="10" height="10" rx="2" fill="#10b981" />
    <text x="16" y="9" class="label">Notas maiores ou iguais a 7</text>
    <text x="310" y="9" class="small">17 estudantes · 60,7%</text>

    <rect x="0" y="22" width="10" height="10" rx="2" fill="#f59e0b" />
    <text x="16" y="31" class="label">Notas entre 5 e 6.9</text>
    <text x="310" y="31" class="small">5 estudantes · 17,9%</text>

    <rect x="0" y="44" width="10" height="10" rx="2" fill="#ef4444" />
    <text x="16" y="53" class="label">Notas abaixo de 5</text>
    <text x="310" y="53" class="small">6 estudantes · 21,4%</text>
  </g>
</svg>

## Q1


<svg viewBox="0 0 473 42" width="100%" height="42" role="img" aria-label="Results for question q1, 28 students">
  <!-- cell size 14x16, gap 3, rx 2 -->
  <rect x="0" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="17" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="34" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="51" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="68" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="85" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="102" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="119" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="136" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="153" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="170" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="187" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="204" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="221" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="238" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="255" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="272" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="289" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="306" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="323" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="340" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="357" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="374" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="391" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="408" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="425" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="442" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="459" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="0" y="24" width="10" height="10" rx="2" fill="#10b981" />
  <text x="15" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">≥ 70%</text>
  <rect x="82" y="24" width="10" height="10" rx="2" fill="#f59e0b" />
  <text x="97" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">50–69%</text>
  <rect x="164" y="24" width="10" height="10" rx="2" fill="#ef4444" />
  <text x="179" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">&lt; 50%</text>
</svg>


``` haskell
func1 :: Int -> Int -> Int
func1 i j = foldr1 (+) $ take 4 [2,4..] ++ [i,j]

resposta1 = func1 2 4

main = do
  print resposta1
```
@LIA.haskell

Obs.: Questão tinha um erro no tipo do resultado!

Conceitos/recursos:

- Listas e concatenação
- Gerador de lista (infinita)
- Funções take e foldr1 (alta ordem)
- Operador `$`
- Tipagem

## Q2

<svg viewBox="0 0 473 42" width="100%" height="42" role="img" aria-label="Results for question q2, 28 students">
  <!-- cell size 14x16, gap 3, rx 2 -->
  <rect x="0" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="17" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="34" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="51" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="68" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="85" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="102" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="119" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="136" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="153" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="170" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="187" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="204" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="221" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="238" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="255" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="272" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="289" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="306" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="323" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="340" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="357" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="374" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="391" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="408" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="425" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="442" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="459" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="0" y="24" width="10" height="10" rx="2" fill="#10b981" />
  <text x="15" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">≥ 70%</text>
  <rect x="82" y="24" width="10" height="10" rx="2" fill="#f59e0b" />
  <text x="97" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">50–69%</text>
  <rect x="164" y="24" width="10" height="10" rx="2" fill="#ef4444" />
  <text x="179" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">&lt; 50%</text>
</svg>

``` haskell
func2 :: Int -> [Int] -> [Int] -> [(Int, Int, Bool)]
func2 n xs ys = filter func list
  where list = take n [(x, y, x == y) | x <- xs, y <- ys]
        func (_, _, z) = z == False

resposta2 = func2 4 [1..] [1..]

main = do
  print resposta2
```
@LIA.haskell


Conceitos/recursos:

- Listas e tuplas
- List comprehension
- Gerador de lista (infinita)
- Funções filter (alta ordem) e take
- Condicionais
- Uso de where
- Tipagem



## Q3

<svg viewBox="0 0 473 42" width="100%" height="42" role="img" aria-label="Results for question q3, 28 students">
  <!-- cell size 14x16, gap 3, rx 2 -->
  <rect x="0" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="17" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="34" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="51" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="68" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="85" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="102" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="119" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="136" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="153" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="170" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="187" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="204" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="221" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="238" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="255" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="272" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="289" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="306" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="323" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="340" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="357" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="374" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="391" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="408" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="425" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="442" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="459" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="0" y="24" width="10" height="10" rx="2" fill="#10b981" />
  <text x="15" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">≥ 70%</text>
  <rect x="82" y="24" width="10" height="10" rx="2" fill="#f59e0b" />
  <text x="97" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">50–69%</text>
  <rect x="164" y="24" width="10" height="10" rx="2" fill="#ef4444" />
  <text x="179" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">&lt; 50%</text>
</svg>

``` haskell
func3 :: [String] -> [(String, Int)]
func3 ss = filter (\t -> snd t > 4) $ map (\s -> (s, length s)) ss

resposta3 = func3 ["Haskell", "Prolog", "Java"]

main = do
  print resposta3
```
@LIA.haskell


Conceitos/recursos:


- Lambdas
- Gerador de lista (infinita)
- Funções de alta ordem: filter e map
- Operador `$`
- Condicionais
- Listas e tuplas
- Tipagem

## Q4

<svg viewBox="0 0 473 42" width="100%" height="42" role="img" aria-label="Results for question q4, 28 students">
  <!-- cell size 14x16, gap 3, rx 2 -->
  <rect x="0" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="17" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="34" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="51" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="68" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="85" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="102" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="119" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="136" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="153" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="170" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="187" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="204" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="221" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="238" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="255" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="272" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="289" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="306" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="323" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="340" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="357" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="374" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="391" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="408" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="425" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="442" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="459" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="0" y="24" width="10" height="10" rx="2" fill="#10b981" />
  <text x="15" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">≥ 70%</text>
  <rect x="82" y="24" width="10" height="10" rx="2" fill="#f59e0b" />
  <text x="97" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">50–69%</text>
  <rect x="164" y="24" width="10" height="10" rx="2" fill="#ef4444" />
  <text x="179" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">&lt; 50%</text>
</svg>


``` haskell
func4 :: [Int] -> [String] -> [(String, String)]
func4 ns ss = map func $ zip ns ss
  where func (n, s) = (if even n then "A" else "B", s)

resposta4 = func4 [10, 11, 12, 13] ["Haskell", "Prolog", "Java"]

main = do
  print resposta4
```
@LIA.haskell


Conceitos/recursos:

- Funções map, zip, even
- Operador `$`
- Condicionais
- Uso de `where`
- Listas e tuplas
- Tipagem


## Q5a

<svg viewBox="0 0 473 42" width="100%" height="42" role="img" aria-label="Results for question q5a, 28 students">
  <!-- cell size 14x16, gap 3, rx 2 -->
  <rect x="0" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="17" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="34" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="51" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="68" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="85" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="102" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="119" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="136" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="153" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="170" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="187" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="204" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="221" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="238" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="255" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="272" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="289" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="306" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="323" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="340" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="357" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="374" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="391" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="408" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="425" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="442" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="459" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="0" y="24" width="10" height="10" rx="2" fill="#10b981" />
  <text x="15" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">≥ 70%</text>
  <rect x="82" y="24" width="10" height="10" rx="2" fill="#f59e0b" />
  <text x="97" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">50–69%</text>
  <rect x="164" y="24" width="10" height="10" rx="2" fill="#ef4444" />
  <text x="179" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">&lt; 50%</text>
</svg>


``` prolog
obj(1, [0.1, 0.2, 0.3, 0.4]).
obj(2, [0.5, 0.6, 0.7, 0.8]).
prop(1, 0.8).
prop(2, 0.95).

rule1(S) :- findall((A, B), obj(_, [A, B, _, _]), S).
```
@LIA.prolog_withShell

```
?- rule1(S).
```

Conceitos/recursos:

- Fatos, regras e variáveis
- Listas
- Variável anônima
- Predicado findall
- Mecanismo de busca com unificação

## Q5b

<svg viewBox="0 0 473 42" width="100%" height="42" role="img" aria-label="Results for question q5b, 28 students">
  <!-- cell size 14x16, gap 3, rx 2 -->
  <rect x="0" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="17" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="34" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="51" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="68" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="85" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="102" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="119" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="136" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="153" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="170" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="187" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="204" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="221" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="238" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="255" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="272" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="289" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="306" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="323" y="2" width="14" height="16" rx="2" fill="#10b981" />
  <rect x="340" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="357" y="2" width="14" height="16" rx="2" fill="#f59e0b" />
  <rect x="374" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="391" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="408" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="425" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="442" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="459" y="2" width="14" height="16" rx="2" fill="#ef4444" />
  <rect x="0" y="24" width="10" height="10" rx="2" fill="#10b981" />
  <text x="15" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">≥ 70%</text>
  <rect x="82" y="24" width="10" height="10" rx="2" fill="#f59e0b" />
  <text x="97" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">50–69%</text>
  <rect x="164" y="24" width="10" height="10" rx="2" fill="#ef4444" />
  <text x="179" y="33" font-size="10" font-family="system-ui, sans-serif" fill="#374151">&lt; 50%</text>
</svg>

``` prolog
obj(1, [0.1, 0.2, 0.3, 0.4]).
obj(2, [0.5, 0.6, 0.7, 0.8]).
prop(1, 0.8).
prop(2, 0.95).

rule2(Id, C, D) :- obj(Id, [_, _, C, D]).
rule3(S) :- prop(Id, Val), Val > 0.9, rule2(Id, Y, Z), S is Y + Z.
```
@LIA.prolog_withShell

```
?- rule3(S).
```

Conceitos/recursos:

- Fatos, regras e variáveis
- Listas
- Variável anônima
- Aritmética e operador relacional
- Mecanismo de busca com unificação e "E" lógico
