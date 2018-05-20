using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Assembler
{
    class Interpreter
    {
        public List<string> Binaries;
        Read fileRead;
        Write writeFile;

        public Interpreter()
        {
            Binaries = new List<string>(256);
            for (int i = 0; i < 256; i++)
                Binaries.Add("0000000000000000");
            writeFile = new Write();
        }

        public void Clear()
        {
            for (int i = 0; i < 256; i++)
            {
                Binaries[i] = "0000000000000000";
            }
        }

        public int Convert(string text, ref string msgError)
        {
            
            Clear();
            fileRead = new Read(text);
            UInt16 address = 0;
            int i=0;
            try
            {
                for (i = 0; i < fileRead.clearFile.Count; i++)
                {
                    string Code = "";
                    string menmonic = fileRead.clearFile[i];
                    menmonic = menmonic.Trim();
                    if (menmonic == "")
                        continue;
                    List<string> datas = menmonic.Split(' ').ToList();
                    for (int j = 0; j < datas.Count; j++)
                    {
                        if (datas[j] == "")
                            datas.RemoveAt(j);
                    }

                    if (datas.Count == 2)
                    {
                        datas.AddRange(datas[1].Split(',').ToList());
                        datas.RemoveAt(1);
                    }
                    else if (datas.Count == 3)
                    {
                        datas[1] = datas[1].Split(',')[0];
                    }
                    else if (datas.Count == 4 && datas[2] == ",")
                    {
                        datas.RemoveAt(2);
                    }

                    string opcode = datas[0];

                    switch (opcode)
                    {
                        case "":
                            {
                                break;
                            }
                        case "nop":
                            {
                                Code = InstructionsOpcode.Nop;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected Operand";
                                    return i;
                                }
                                Code += "00000000000";
                                Binaries[address] = Code;
                                Binaries[address+1] = "0000000000000000";
                                address+=2;
                                break;
                            }
                        case "setc":
                            {
                                Code = InstructionsOpcode.SETC;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected Operand";
                                    return i;
                                }
                                Code += "00000000000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;
                                
                                break;
                            }
                        case "clrc":
                            {
                                Code = InstructionsOpcode.CLRC;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected Operand";
                                    return i;
                                }
                                Code += "00000000000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;
                                break;
                            }
                        case "ldd":
                            {
                                Code = InstructionsOpcode.LDD;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: "+reg;
                                    return i;
                                }
                                else Code += reg;

                              //  Code += "00000000";
                          //      Binaries[address] = Code;
                          //      address++;
                                UInt32 oper2 = System.Convert.ToUInt32(datas[2]);
                                if (oper2 > 255)
                                {
                                    msgError = "you exceed the limit of the memory. The memory is 256 words only";
                                    return i;
                                }
                                string  ea = System.Convert.ToString((byte)oper2, 2);
                                ea = ea.PadLeft(16, '0');

                                string sub1 = ea.Substring(0, 8);
                                Code += sub1;
                                
                                string sub2 = ea.Substring(8, 8);

                                Binaries[address] = Code;
                                Binaries[address+1] = sub2 + "00000000";
                                address+=2;

                                break;
                            }
                        case "std":
                            {
                                Code = InstructionsOpcode.STD;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

//                                Code += "00000000";
                                //Binaries[address] = Code;
                                //address++;
                                UInt32 oper2 = System.Convert.ToUInt32(datas[2]);
                                if (oper2 > 255)
                                {
                                    msgError = "you exceed the limit of the memory. The memory is 256 bytes only";
                                    return i;
                                }
                                string ea = System.Convert.ToString((byte)oper2, 2);
                                ea = ea.PadLeft(16, '0');

                                string sub1 = ea.Substring(0, 8);
                                Code += sub1;

                                string sub2 = ea.Substring(8, 8);


                                Binaries[address] = Code;
                                Binaries[address + 1] = sub2 + "00000000";
                                address += 2;
                                break;
                            }
                        case "ldm":
                            {
                                Code = InstructionsOpcode.LDM;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                //Code += "00000000";
                        //        Binaries[address] = Code;
                        //        address++;
                                int oper2 = System.Convert.ToInt32(datas[2]);
                                if (oper2 > 255 || oper2 < -128)
                                {
                                    msgError = "The value couldn't be fit in one byte";
                                    return i;
                                }
                                string imm = System.Convert.ToString((byte)oper2, 2);
                                if (oper2 >= 0)
                                    imm = imm.PadLeft(16, '0');
                                else
                                    imm = imm.PadLeft(16, '1');
                        //        Code += imm;

                                string sub1 = imm.Substring(0, 8);
                                Code += sub1;

                                string sub2 = imm.Substring(8, 8);

                                
                                Binaries[address] = Code;
                                Binaries[address + 1] = sub2 + "00000000";
                                address += 2;
                                break;
                            }
                        case "add":
                            {
                                Code = InstructionsOpcode.ADD;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "sub":
                            {
                                Code = InstructionsOpcode.SUB;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "and":
                            {
                                Code = InstructionsOpcode.AND;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }

                        case "or":
                            {
                                Code = InstructionsOpcode.OR;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "not":
                            {
                                Code = InstructionsOpcode.NOT;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "inc":
                            {
                                Code = InstructionsOpcode.INC;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "dec":
                            {
                                Code = InstructionsOpcode.DEC;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "neg":
                            {
                                Code = InstructionsOpcode.NEG;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }

                        case "rlc":
                            {
                                Code = InstructionsOpcode.RLC;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "rrc":
                            {
                                Code = InstructionsOpcode.RRC;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "push":
                            {
                                Code = InstructionsOpcode.PUSH;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "pop":
                            {
                                Code = InstructionsOpcode.POP;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "out":
                            {
                                Code = InstructionsOpcode.OUT;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "in":
                            {
                                Code = InstructionsOpcode.IN;

                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "mov":
                            {
                                Code = InstructionsOpcode.MOV;
                                if (datas.Count != 3)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[2]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "jmp":
                            {
                                Code = InstructionsOpcode.JMP;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;

                                Code += "00000000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "jz":
                            {
                                Code = InstructionsOpcode.JZ;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "jn":
                            {
                                Code = InstructionsOpcode.JN;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "jc":
                            {
                                Code = InstructionsOpcode.JC;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "call":
                            {
                                Code = InstructionsOpcode.CALL;
                                if (datas.Count != 2)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[1]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                Code += "00000000";
                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "shl":
                            {
                                Code = InstructionsOpcode.SHL;
                                if (datas.Count != 4)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[3]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                // 2nd Oprand SHL R1,2,R3 => 2nd register at 3
                                string reg2 = FetchOperand(datas[1]);
                                if (reg2 == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg2;

                                

                                //Code += "00000";
                                UInt32 oper2 = System.Convert.ToUInt32(datas[2]);
                                if (oper2 > 255)
                                {
                                    msgError = "you exceed the limit of the memory. The memory is 256 words only";
                                    return i;
                                }

                                string ea = System.Convert.ToString((byte)oper2, 2);
                                ea = ea.PadLeft(16, '0');
                                //Code += ea;

                                string sub1 = ea.Substring(0, 5);
                                Code += sub1;

                                string sub2 = ea.Substring(5, 11);

                                
                                
                                Binaries[address] = Code;
                                Binaries[address + 1] = sub2 + "00000";
                                address += 2;
                                break;

                            }
                        case "shr":
                            {
                                Code = InstructionsOpcode.SHR;
                                if (datas.Count != 4)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                string reg = FetchOperand(datas[3]);
                                if (reg == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg;
                                // 2nd Oprand SHL R1,2,R3 => 2nd register at 3
                                string reg2 = FetchOperand(datas[1]);
                                if (reg2 == "")
                                {
                                    msgError = "Unexpected operand: " + reg;
                                    return i;
                                }
                                else Code += reg2;
//                                Code += "00000";
                                UInt32 oper2 = System.Convert.ToUInt32(datas[2]);
                                if (oper2 > 255)
                                {
                                    msgError = "you exceed the limit of the memory. The memory is 256 words only";
                                    return i;
                                }

                                string ea = System.Convert.ToString((byte)oper2, 2);
                                ea = ea.PadLeft(16, '0');
                                //Code += ea;

                                string sub1 = ea.Substring(0, 5);
                                Code += sub1;

                                string sub2 = ea.Substring(5, 11);

                                
                                Binaries[address] = Code;
                                Binaries[address + 1] = sub2 + "00000";
                                address += 2;
                                break;
                            }
                        case "ret":
                            {
                                Code = InstructionsOpcode.RET;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }
                                Code += "00000000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                        case "rti":
                            {
                                Code = InstructionsOpcode.RTI;
                                if (datas.Count != 1)
                                {
                                    msgError = "Unexpected number of operands";
                                    return i;
                                }

                                Code += "00000000000";

                                Binaries[address] = Code;
                                Binaries[address + 1] = "0000000000000000";
                                address += 2;

                                break;
                            }
                         default:
                            {
                                Int32 Num;
                                if (opcode[0] == '.' && datas.Count == 1)
                                {
                                    UInt16 add = (UInt16)System.Convert.ToInt16(opcode.Substring(1));
                                    if (add > 255)
                                    {
                                        msgError = "you exceed the limit of the memory. The memory is 256 bytes only";
                                        return i;
                                    }
                                    else
                                    {
                                        address = add;
                                        break;
                                    }
                                }
                                else if (Int32.TryParse(opcode, out Num))
                                {                        
                                     if (Num > 65535 || Num < -32768)
                                    {
                                        msgError = "The value couldn't be fit in one word";
                                        return i;
                                    }
                                    else
                                    {
                                        Code = System.Convert.ToString(Num, 2); 
                                        if (Num >= 0)
                                            Code = Code.PadLeft(16, '0');
                                        else
                                            Code = Code.PadLeft(16, '1');
                                        Binaries[address] = Code;
                                        address++;
                                        break;
                                    }
                                }
                                msgError = "Unknown Instruction "+ datas[0];
                                return i;                             
                                
                            }
                    }
                    if (address > 255)
                    {
                        msgError = "you exceed the limit of the memory. The memory is 256 bytes only";
                        return i; 
                    }
                }

                int index = text.LastIndexOf('.');
                string path = text.Substring(0, index+1);
                path += "mem";
                writeFile.WriteFile(path, Binaries);
                return -1;
            }
            catch(Exception exc)
            {
                return i;
            }

        }

        public string FetchOperand(string s)
        {
            if (s == "r0")
                return "000";
            else if(s == "r1")
                return "001";
            else if(s == "r2")
                return "010";
            else if(s == "r3")
                return "011";
            else if (s == "r4")
                return "100";
            else if (s == "r5")
                return "101";
            else if (s == "r6")
                return "110";
            else if (s == "r7")
                return "111";
            else return "";
        }
    }
}
